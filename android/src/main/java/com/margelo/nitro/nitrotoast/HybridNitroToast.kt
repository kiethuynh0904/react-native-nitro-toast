package com.margelo.nitro.nitrotoast

import com.margelo.nitro.NitroModules

class HybridNitroToast : HybridNitroToastSpec() {
    override val memorySize: Long
        get() = 0L

    override fun show(message: String, config: NitroToastConfig): String {
        val toastId = java.util.UUID.randomUUID().toString()
        NitroModules.applicationContext?.currentActivity?.let { activity ->
            ToastManager.show(activity, toastId, message, config)
        }
        return toastId
    }

    override fun dismiss(toastId: String) {
        ToastManager.dismiss(toastId)
    }
}