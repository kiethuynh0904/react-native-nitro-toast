import { useColorScheme } from 'react-native'

export type Theme = {
  dark: boolean
  bg: string
  bgElevated: string
  card: string
  cardBorder: string
  text: string
  textMuted: string
  textFaint: string
  primary: string
  primaryText: string
  controlBg: string
  controlText: string
  divider: string
  // Toast type accents (kept in sync with the native asset colors)
  success: string
  error: string
  warning: string
  info: string
  neutral: string
}

const light: Theme = {
  dark: false,
  bg: '#F2F3F7',
  bgElevated: '#FFFFFF',
  card: '#FFFFFF',
  cardBorder: '#E6E8EF',
  text: '#11141A',
  textMuted: '#5B616E',
  textFaint: '#9AA0AC',
  primary: '#4F46E5',
  primaryText: '#FFFFFF',
  controlBg: '#EDEFF5',
  controlText: '#11141A',
  divider: '#ECEEF3',
  success: '#22C55E',
  error: '#EF4444',
  warning: '#F59E0B',
  info: '#3B82F6',
  neutral: '#6B7280',
}

const dark: Theme = {
  dark: true,
  bg: '#0B0D12',
  bgElevated: '#14171F',
  card: '#161A22',
  cardBorder: '#252A35',
  text: '#F4F6FB',
  textMuted: '#A6ADBB',
  textFaint: '#6B7280',
  primary: '#6366F1',
  primaryText: '#FFFFFF',
  controlBg: '#1E2330',
  controlText: '#F4F6FB',
  divider: '#222734',
  success: '#34D399',
  error: '#F87171',
  warning: '#FBBF24',
  info: '#60A5FA',
  neutral: '#9CA3AF',
}

export function useTheme(): Theme {
  return useColorScheme() === 'dark' ? dark : light
}

export const spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
} as const

export const radius = {
  sm: 8,
  md: 12,
  lg: 16,
  pill: 999,
} as const

/** Linked custom fonts available in the example app (see assets/fonts). */
export const demoFonts = {
  rubik: 'Rubik',
  delius: 'Delius',
} as const
