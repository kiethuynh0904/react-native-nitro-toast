import { type NitroToastConfig } from './specs/NitroToast.nitro'

export type ValueFunction<TValue, TArg> = (arg: TArg) => TValue
export type ValueOrFunction<TValue, TArg> = TValue | ValueFunction<TValue, TArg>

export type ToastPromiseMessages<T> = {
  loading: string
  success: ValueOrFunction<string, T>
  error: ValueOrFunction<string, any>
}

export type ToastPromiseConfig = Partial<NitroToastConfig> & {
  loading?: Partial<NitroToastConfig>
  success?: Partial<NitroToastConfig>
  error?: Partial<NitroToastConfig>
}
