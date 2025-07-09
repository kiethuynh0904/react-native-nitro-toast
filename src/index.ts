export * from './specs/NitroToast.nitro'

import { NitroModules } from 'react-native-nitro-modules'
import {
  type NitroToast,
  type NitroToastConfig,
} from './specs/NitroToast.nitro'
import type { ToastPromiseMessages, ToastPromiseConfig } from './types'

const NitroToastModule =
  NitroModules.createHybridObject<NitroToast>('NitroToast')

export const defaultToastConfig: NitroToastConfig = {
  type: 'default',
  presentation: 'alert',
  duration: 4000,
  position: 'bottom',
  useOverlay: true,
}

/**
 * Shows a toast message.
 * @param message The message to display.
 * @param config Optional configuration for the toast.
 * @returns The toast ID.
 */
export const showToast = (
  message: string,
  config?: Partial<NitroToastConfig>
): string => {
  const isLoading = config?.type === 'loading'
  if (isLoading) {
    defaultToastConfig.duration = 0
  }
  const _config: NitroToastConfig = {
    ...defaultToastConfig,
    ...config,
  }
  return NitroToastModule.show(message, _config)
}

/**
 * Dismisses a toast by its ID.
 * @param id The toast ID to dismiss.
 */
export const dismissToast = (id: string): void => {
  NitroToastModule.dismiss(id)
}

/**
 * Resolves a message that can be either a string or a function that returns a string.
 * @param msg The message (string or function)
 * @param arg The argument to pass to the function if it's a function
 * @returns The resolved string message
 */
function resolveMessage<T>(msg: string | ((arg: T) => string), arg: T): string {
  return typeof msg === 'function' ? msg(arg) : msg
}

/**
 * Shows a loading toast while a promise is pending, then updates to success or error.
 * @param promise The promise to track.
 * @param messages The messages for loading, success, and error states.
 * @param config Toast configuration with global options and per-state overrides.
 * @returns The resolved value of the promise.
 */
export async function showToastPromise<T>(
  promise: Promise<T> | (() => Promise<T>),
  messages: ToastPromiseMessages<T>,
  config: ToastPromiseConfig
): Promise<T> {
  const toastId = showToast(messages.loading, {
    type: 'loading',
    ...config,
    ...config?.loading,
  })

  if (typeof promise === 'function') {
    promise = promise()
  }

  try {
    const result = await promise

    showToast(resolveMessage(messages.success, result), {
      type: 'success',
      ...config,
      ...config?.success,
      toastId,
    })

    return result
  } catch (err) {
    showToast(resolveMessage(messages.error, err), {
      type: 'error',
      ...config,
      ...config?.error,
      toastId,
    })
    throw err
  }
}
