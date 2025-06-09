package com.margelo.nitro.nitrotoast
import com.margelo.nitro.NitroModules

class HybridNitroToast: HybridNitroToastSpec() {
    override val memorySize:Long
        get() = 0L
    private val toastModule = HybridNitroToastModule(NitroModules.applicationContext)

    override fun show(message: String, config: NitroToastConfig) {
        toastModule.show(message,config)
    }
}