package com.margelo.nitro.nitrotoast

import com.margelo.nitro.NitroModules

class HybridNitroToast : HybridNitroToastSpec() {
    override val memorySize: Long
        get() = 0L

    override fun show(message: String, config: NitroToastConfig) {
        val activity = NitroModules.applicationContext?.currentActivity
        if (activity != null) {
            ToastManager.show(activity, message, config)
        }
    }
}