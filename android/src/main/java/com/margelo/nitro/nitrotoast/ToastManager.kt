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
    private val _toasts = MutableStateFlow<List<Toast>>(emptyList())
    val toasts = _toasts.asStateFlow()

    fun addToast(toast: Toast) {
        _toasts.value += toast
    }

    fun updateToastVisibility(toastId: String, isVisible: Boolean) {
        _toasts.value = _toasts.value.map {
            if (it.id == toastId) it.copy(isVisible = isVisible) else it
        }
    }

    suspend fun removeToast(toastId: String) {
        // Set isVisible = false (exit animation trigger)
        _toasts.value = _toasts.value.map {
            if (it.id == toastId) it.copy(isVisible = false) else it
        }
        delay(300) // wait for animation to finish
        // Actually remove from list
        _toasts.value = _toasts.value.filterNot { it.id == toastId }
    }

}

object ToastManager {
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private var toastContainer: ComposeView? = null
    private val toastListState = ToastListState()

    @SuppressLint("SuspiciousIndentation")
    fun show(context: Context?, message: String, config: NitroToastConfig) {
        if (context !is Activity) return

        val toast = Toast(message = message, config = config, isVisible = false)
        toastListState.addToast(toast)

        context.runOnUiThread {
            if (toastContainer == null) {
                toastContainer = ComposeView(context).apply {
                    setContent {
                        ToastList(state = toastListState)
                    }
                    layoutParams = ViewGroup.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT
                    )
                }
                (context.window?.decorView as? ViewGroup)?.addView(toastContainer)
            }

            Log.d("ToastManager", "Showing toast: ${toastListState.toasts.value}")
            scope.launch {
                // Delay briefly to allow AnimatedVisibility to detect false -> true transition
                delay(16)
                toastListState.updateToastVisibility(toast.id, true)

                delay(config.duration.toLong() - 300)
                toastListState.removeToast(toast.id)

                context.runOnUiThread {
                    Log.d("ToastManager", "Removing toast: ${toast.id}")
                    if (toastListState.toasts.value.isEmpty()) {
                        (context.window?.decorView as? ViewGroup)?.removeView(toastContainer)
                        toastContainer = null
                    }
                }
            }
        }
    }
}