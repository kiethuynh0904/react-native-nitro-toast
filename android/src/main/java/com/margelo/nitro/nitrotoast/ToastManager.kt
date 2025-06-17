package com.margelo.nitro.nitrotoast

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.ViewGroup
import androidx.compose.ui.platform.ComposeView
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

class ToastListState {
    private val _toasts = MutableStateFlow(emptyList<Toast>())
    val toasts = _toasts.asStateFlow()

    fun add(toast: Toast) {
        _toasts.value += toast
    }

    fun updateVisibility(toastId: String, isVisible: Boolean) {
        _toasts.value = _toasts.value.map {
            if (it.id == toastId) it.copy(isVisible = isVisible) else it
        }
    }

    suspend fun removeWithAnimation(toastId: String) {
        updateVisibility(toastId, false)
        delay(300)
        _toasts.value = _toasts.value.filterNot { it.id == toastId }
    }
}

object ToastManager {
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private var toastContainer: ComposeView? = null
    private val state = ToastListState()

    @SuppressLint("SuspiciousIndentation")
    fun show(context: Context?, message: String, config: NitroToastConfig) {
        if (context !is Activity) return

        val toast = Toast(message = message, config = config, isVisible = false)
        state.add(toast)

        context.runOnUiThread {
            ensureToastContainer(context)
            scope.launch { handleToastLifecycle(context, toast, config.duration) }
        }
    }

    private fun ensureToastContainer(context: Activity) {
        if (toastContainer != null) return

        toastContainer = ComposeView(context).apply {
            setContent { ToastList(state = state) }
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        }

        (context.window?.decorView as? ViewGroup)?.addView(toastContainer)
    }

    private suspend fun handleToastLifecycle(context: Activity, toast: Toast, duration: Double) {
        delay(16)
        state.updateVisibility(toast.id, true)
        delay(duration.toLong() - 300)
        state.removeWithAnimation(toast.id)

        context.runOnUiThread {
            Log.d("ToastManager", "Removing toast: ${toast.id}")
            if (state.toasts.value.isEmpty()) {
                (context.window?.decorView as? ViewGroup)?.removeView(toastContainer)
                toastContainer = null
            }
        }
    }
}