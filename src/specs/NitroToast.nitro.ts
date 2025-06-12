import type { HybridObject } from 'react-native-nitro-modules'

export type AlertToastType =
  | 'success'
  | 'error'
  | 'warning'
  | 'info'
  | 'default'
export type PresentationToastType = 'alert' | 'stacked'
export type PositionToastType = 'top' | 'bottom'
export type NitroToastConfig = {
  type: AlertToastType
  presentation: PresentationToastType
  duration: number // in milliseconds
  title?: string
  position: PositionToastType
  backgroundColor?: string
  titleColor?: string
  messageColor?: string
  useOverlay: boolean
}
export interface NitroToast
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  show(message: string, config: NitroToastConfig): void
}
