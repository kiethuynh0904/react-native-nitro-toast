import type { HybridObject } from 'react-native-nitro-modules'

export type NitroToastType = 'success' | 'error' | 'warning' | 'info'

export interface NitroToast
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  show(message: string, type: NitroToastType): void
}
