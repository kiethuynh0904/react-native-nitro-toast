import { beforeEach, describe, expect, mock, test } from 'bun:test'

type ShowCall = { message: string; config: Record<string, unknown> }

let showCalls: ShowCall[] = []
let dismissCalls: string[] = []
let dismissAllCount = 0
let idCounter = 0

const fakeModule = {
  show(message: string, config: Record<string, unknown>) {
    showCalls.push({ message, config })
    return `id-${++idCounter}`
  },
  dismiss(id: string) {
    dismissCalls.push(id)
  },
  dismissAll() {
    dismissAllCount++
  },
}

// index.ts calls createHybridObject at load time — register the mock first.
mock.module('react-native-nitro-modules', () => ({
  NitroModules: { createHybridObject: () => fakeModule },
}))

const {
  showToast,
  dismissToast,
  dismissAllToasts,
  showToastPromise,
  defaultToastConfig,
  configure,
} = await import('../src/index')

beforeEach(() => {
  showCalls = []
  dismissCalls = []
  dismissAllCount = 0
  idCounter = 0
})

describe('showToast', () => {
  test('merges defaults from defaultToastConfig', () => {
    showToast('hello')
    expect(showCalls).toHaveLength(1)
    expect(showCalls[0]!.message).toBe('hello')
    expect(showCalls[0]!.config).toMatchObject(defaultToastConfig)
  })

  test('caller config overrides defaults', () => {
    showToast('x', { position: 'top', type: 'success' })
    expect(showCalls[0]!.config.position).toBe('top')
    expect(showCalls[0]!.config.type).toBe('success')
  })

  test('loading type defaults duration to 0 (sticky)', () => {
    showToast('x', { type: 'loading' })
    expect(showCalls[0]!.config.duration).toBe(0)
  })

  test('explicit duration wins for loading', () => {
    showToast('x', { type: 'loading', duration: 1500 })
    expect(showCalls[0]!.config.duration).toBe(1500)
  })

  test('non-loading keeps the default duration', () => {
    showToast('x', { type: 'success' })
    expect(showCalls[0]!.config.duration).toBe(defaultToastConfig.duration)
  })

  test('returns the native toast id', () => {
    expect(showToast('x')).toBe('id-1')
  })
})

describe('dismissToast', () => {
  test('forwards the id to native dismiss', () => {
    dismissToast('abc')
    expect(dismissCalls).toEqual(['abc'])
  })

  test('dismissAllToasts calls native dismissAll', () => {
    dismissAllToasts()
    expect(dismissAllCount).toBe(1)
  })
})

describe('showToastPromise', () => {
  test('loading then success, reusing the toast id; resolves the value', async () => {
    const result = await showToastPromise(
      Promise.resolve({ message: 'done' }),
      { loading: 'loading…', success: (r) => r.message, error: 'err' },
      { position: 'top' }
    )
    expect(result).toEqual({ message: 'done' })
    expect(showCalls).toHaveLength(2)
    expect(showCalls[0]!.config.type).toBe('loading')
    expect(showCalls[1]!.config.type).toBe('success')
    expect(showCalls[1]!.message).toBe('done')
    expect(showCalls[1]!.config.toastId).toBe('id-1')
  })

  test('shows error and rejects on failure', async () => {
    await expect(
      showToastPromise(
        Promise.reject(new Error('boom')),
        { loading: 'loading…', success: 'ok', error: (e) => (e as Error).message },
        {}
      )
    ).rejects.toThrow('boom')
    expect(showCalls[1]!.config.type).toBe('error')
    expect(showCalls[1]!.message).toBe('boom')
  })

  test('accepts a promise-returning function', async () => {
    const result = await showToastPromise(
      () => Promise.resolve('v'),
      { loading: 'l', success: (r) => String(r), error: 'e' },
      {}
    )
    expect(result).toBe('v')
  })
})

describe('configure', () => {
  test('app-wide defaults apply, under per-call config', () => {
    configure({ position: 'top' })
    showToast('x')
    expect(showCalls[0]!.config.position).toBe('top')

    showCalls = []
    showToast('y', { position: 'bottom' })
    expect(showCalls[0]!.config.position).toBe('bottom') // per-call wins

    configure({ position: 'bottom' }) // restore built-in default (avoid cross-file leak)
  })
})
