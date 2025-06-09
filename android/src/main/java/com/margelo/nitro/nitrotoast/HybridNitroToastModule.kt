package com.margelo.nitro.nitrotoast

import android.widget.Toast
import com.facebook.react.bridge.BaseJavaModule
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.turbomodule.core.interfaces.TurboModule

@ReactModule(name = HybridNitroToastModule.NAME)
class HybridNitroToastModule(private val reactContext: ReactApplicationContext?) :
    BaseJavaModule(), TurboModule {
    companion object {
        const val NAME = "HybridNitroToast"
    }

    override fun getName(): String = NAME

    @ReactMethod
    fun show(message:String,config: NitroToastConfig) {
//        ToastManager.show(reactContext, message,config)
    }
}