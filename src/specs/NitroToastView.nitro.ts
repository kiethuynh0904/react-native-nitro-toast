import type {
  HybridView,
  HybridViewMethods,
  HybridViewProps,
} from 'react-native-nitro-modules'

export interface NitroToastViewProps extends HybridViewProps {}

export interface NitroToastViewMethods extends HybridViewMethods {}

export type NitroToastView = HybridView<
  NitroToastViewProps,
  NitroToastViewMethods
>
