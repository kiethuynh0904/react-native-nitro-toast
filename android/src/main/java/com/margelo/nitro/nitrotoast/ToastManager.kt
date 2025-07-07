package com.margelo.nitro.nitrotoast

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.util.Log
import android.view.ViewGroup
import androidx.annotation.RequiresPermission
import androidx.compose.ui.platform.ComposeView
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

class ToastListState {
    private val _toasts = MutableStateFlow(emptyList<Toast>())
    val toasts = _toasts.asStateFlow()

    val _pauseMap = MutableStateFlow<Map<String,Boolean>>(emptyMap())

    val pauseMap = _pauseMap.asStateFlow()

    fun setPaused(toastId:String,paused:Boolean){
        _pauseMap.value = _pauseMap.value.toMutableMap().apply {
            put(toastId,paused)
        }
    }

    fun add(toast: Toast) {
        _toasts.value += toast
    }

    fun updateVisibility(toastId: String, isVisible: Boolean) {
        _toasts.value = _toasts.value.map {
            if (it.id == toastId) it.copy(isVisible = isVisible) else it
        }
    }

    fun setUpdating(toastId: String, isUpdating: Boolean) {
        _toasts.value = _toasts.value.map {
            if (it.id == toastId) it.copy(isUpdating = isUpdating) else it
        }
    }

    fun updateToast(toastId: String, message: String, config: NitroToastConfig) {
        _toasts.value = _toasts.value.map {
            if (it.id == toastId) it.copy(message = message, config = config) else it
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
    private val lifecycleJobs = mutableMapOf<String, Job>()

    @SuppressLint("MissingPermission")
    fun show(context: Context?, toastId: String, message: String, config: NitroToastConfig) {
        if (context !is Activity) return

        // Always trigger haptics if requested, regardless of new or updating
        if (config.haptics == true) {
            triggerHaptics(context, config.type)
        }

        val existingToast = state.toasts.value.find { it.id == toastId }
        if (existingToast != null) {
            updateToast(toastId, message, config)
        } else {
            val toast = Toast(id = toastId, message = message, config = config, isVisible = false)
            state.add(toast)
            context.runOnUiThread {
                ensureToastContainer(context)
                lifecycleJobs[toastId] = scope.launch { handleToastLifecycle(toast, config.duration) }
            }
        }
    }

    // Helper function to update toast content and trigger animation
    private fun updateToast(toastId: String, message: String, config: NitroToastConfig) {
        state.updateToast(toastId, message, config)
        state.setUpdating(toastId,true)
        scope.launch {
            delay(300)
            state.setUpdating(toastId,false)
        }
        lifecycleJobs[toastId]?.cancel()
        val updatedToast = state.toasts.value.find { it.id == toastId }
        if (updatedToast != null) {
            lifecycleJobs[toastId] = scope.launch { handleToastLifecycle(updatedToast, config.duration) }
        }
    }

    fun dismiss(toastId: String) {
        scope.launch {
            state.removeWithAnimation(toastId)
            lifecycleJobs[toastId]?.cancel()
            lifecycleJobs.remove(toastId)
            checkAndRemoveContainer()
        }
    }


    @RequiresPermission(Manifest.permission.VIBRATE)
    private fun triggerHaptics(context: Context, type: AlertToastType?) {
        val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        if (vibrator != null && vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val effect = when (type) {
                    AlertToastType.SUCCESS -> VibrationEffect.createOneShot(40, VibrationEffect.DEFAULT_AMPLITUDE)
                    AlertToastType.ERROR -> VibrationEffect.createOneShot(60, VibrationEffect.DEFAULT_AMPLITUDE)
                    AlertToastType.WARNING -> VibrationEffect.createOneShot(50, VibrationEffect.DEFAULT_AMPLITUDE)
                    else -> VibrationEffect.createOneShot(30, VibrationEffect.DEFAULT_AMPLITUDE)
                }
                vibrator.vibrate(effect)
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(40)
            }
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

    private suspend fun handleToastLifecycle(toast: Toast, duration: Double) {
        delay(16)
        state.updateVisibility(toast.id, true)
        Log.d("ToastManager", "Showing toast: $toast")

        if (duration > 0) {
            var remaining = duration.toLong() - 300
            val interval = 100L
            while (remaining > 0) {
                delay(interval)
                remaining -= interval
            }
            state.removeWithAnimation(toast.id)
        }

        checkAndRemoveContainer()
    }

    private fun checkAndRemoveContainer() {
        val context = toastContainer?.context as? Activity ?: return
        CoroutineScope(Dispatchers.Main).launch {
            delay(300)
            if (state.toasts.value.isEmpty()) {
                (context.window?.decorView as? ViewGroup)?.removeView(toastContainer)
                toastContainer = null
            }
        }
    }
}