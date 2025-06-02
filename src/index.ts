import { NitroModules } from 'react-native-nitro-modules'
import type { NitroToast, NitroToastType } from './specs/NitroToast.nitro'

// TODO: Export all HybridObjects here for the user
// export * from './views/NitroToastView'
export * from './specs/NitroToast.nitro'

const NitroToastModule = NitroModules.createHybridObject<NitroToast>(
    'NitroToast'
  )

export const showToast = (message: string, type: NitroToastType) => {
    NitroToastModule.show(message, type)
}