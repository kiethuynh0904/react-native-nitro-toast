import { NitroModules } from 'react-native-nitro-modules'
import {
  DEFAULT_TOAST_CONFIG,
  type NitroToast,
  type NitroToastConfig,
} from './specs/NitroToast.nitro'

// TODO: Export all HybridObjects here for the user
export * from './views/NitroToastView'
export * from './specs/NitroToast.nitro'

const NitroToastModule =
  NitroModules.createHybridObject<NitroToast>('NitroToast')

export const showToast = (
  message: string,
  config?: Partial<NitroToastConfig>
) => {
  const _config: NitroToastConfig = {
    ...DEFAULT_TOAST_CONFIG,
    ...config,
  }
  NitroToastModule.show(message, _config)
}
