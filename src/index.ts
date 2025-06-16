export * from './specs/NitroToast.nitro'

import { NitroModules } from 'react-native-nitro-modules'
import {
  type NitroToast,
  type NitroToastConfig,
} from './specs/NitroToast.nitro'

const NitroToastModule =
  NitroModules.createHybridObject<NitroToast>('NitroToast')

export const defaultToastConfig: NitroToastConfig = {
  type: 'default',
  presentation: 'alert',
  duration: 4000,
  position: 'bottom',
  useOverlay: true,
}

export const showToast = (
  message: string,
  config?: Partial<NitroToastConfig>
) => {
  const _config: NitroToastConfig = {
    ...defaultToastConfig,
    ...config,
  }
  NitroToastModule.show(message, _config)
}
