package com.margelo.nitro.nitrotoast

import android.util.Log
import com.facebook.react.bridge.BaseJavaModule
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
    fun show(message: String, config: NitroToastConfig) {
        try {
            val activity = reactContext?.currentActivity
            if (activity == null) {
                Log.w("HybridNitroToastModule", "No current Activity available to show toast")
                return
            }
            ToastManager.show(activity, message, config)
        } catch (e: Exception) {
            Log.e("HybridNitroToastModule", "Error in show()", e)
            throw e // or send error back to JS
        }
    }
}