export * from './specs/NitroToast.nitro'

import { NitroModules } from 'react-native-nitro-modules'
import {
  type NitroToast,
  type NitroToastConfig,
} from './specs/NitroToast.nitro'

const NitroToastModule =
  NitroModules.createHybridObject<NitroToast>('NitroToast')

export const DEFAULT_TOAST_CONFIG: NitroToastConfig = {
  type: 'default',
  presentation: 'alert',
  duration: 3000,
  position: 'bottom',
}

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
