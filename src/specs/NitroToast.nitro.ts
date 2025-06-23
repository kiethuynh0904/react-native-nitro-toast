import type { HybridObject } from 'react-native-nitro-modules'

/**
 * Type of toast notification to display.
 * - `success`: Green toast with checkmark icon
 * - `error`: Red toast with error icon
 * - `warning`: Yellow toast with warning icon
 * - `info`: Blue toast with info icon
 * - `default`: Gray toast with default icon
 */
export type AlertToastType =
  | 'success'
  | 'error'
  | 'warning'
  | 'info'
  | 'default'

/**
 * How the toast should be presented on screen.
 * - `alert`: Single toast notification
 * - `stacked`: Multiple toasts stacked on top of each other
 */
export type PresentationToastType = 'alert' | 'stacked'

/**
 * Position of the toast on screen.
 * - `top`: Toast appears at the top of the screen
 * - `bottom`: Toast appears at the bottom of the screen
 */
export type PositionToastType = 'top' | 'bottom'

/**
 * Configuration options for toast notifications.
 */
export type NitroToastConfig = {
  /** Type of toast to display */
  type: AlertToastType
  /** How the toast should be presented */
  presentation: PresentationToastType
  /** Duration in milliseconds before toast auto-dismisses (0 for no auto-dismiss) */
  duration: number
  /** Optional title text to display above the message */
  title?: string
  /** Position of the toast on screen */
  position: PositionToastType
  /** Custom background color in HEX format (e.g. '#FF0000') */
  backgroundColor?: string
  /** Custom title text color in HEX format */
  titleColor?: string
  /** Custom message text color in HEX format */
  messageColor?: string
  /** Whether to show a semi-transparent overlay behind the toast */
  useOverlay: boolean
  /** Whether to trigger haptic feedback when toast appears */
  haptics?: boolean
  /** Your custom icon to display in the toast */
  iconUri?: string
}

/**
 * Native toast module interface.
 * Handles the actual display of toast notifications on iOS and Android.
 */
export interface NitroToast
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  /**
   * Shows a toast notification with the given message and configuration.
   * @param message - The text message to display in the toast
   * @param config - Configuration options for the toast
   */
  show(message: string, config: NitroToastConfig): void
}
