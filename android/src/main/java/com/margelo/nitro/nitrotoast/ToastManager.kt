//package com.margelo.nitro.nitrotoast
//
//import android.app.Activity
//import android.content.Context
//import android.view.Gravity
//import android.view.ViewGroup
//import android.view.WindowManager
//import android.widget.FrameLayout
//import androidx.compose.animation.*
//import androidx.compose.foundation.background
//import androidx.compose.foundation.layout.*
//import androidx.compose.foundation.shape.RoundedCornerShape
//import androidx.compose.material.icons.Icons
//import androidx.compose.material.icons.filled.CheckCircle
//import androidx.compose.material.icons.filled.Close
//import androidx.compose.material.icons.filled.Info
//import androidx.compose.material.icons.filled.Warning
//import androidx.compose.material3.Icon
//import androidx.compose.material3.MaterialTheme
//import androidx.compose.material3.Text
//import androidx.compose.runtime.*
//import androidx.compose.ui.Alignment
//import androidx.compose.ui.Modifier
//import androidx.compose.ui.graphics.Color
//import androidx.compose.ui.platform.ComposeView
//import androidx.compose.ui.text.font.FontWeight
//import androidx.compose.ui.unit.dp
//import androidx.compose.ui.unit.sp
//import kotlinx.coroutines.*
//
//object ToastManager {
//    private var toastContainer: FrameLayout? = null
//    private var toastJob: Job? = null
//    private val toasts = mutableStateListOf<Toast>()
//
//    fun show(context: Context?, message: String, config: NitroToastConfig) {
//        if (context !is Activity) return
//
//        val toast = Toast(
//            message = message,
//            config = config
//        )
//        toasts.add(toast)
//
//        if (toastContainer == null) {
//            createToastContainer(context)
//        }
//
//        toastJob?.cancel()
//        toastJob = CoroutineScope(Dispatchers.Main).launch {
//            delay(config.duration.toLong())
//            toasts.remove(toast)
//            if (toasts.isEmpty()) {
//                removeToastContainer(context)
//            }
//        }
//    }
//
//    private fun createToastContainer(context: Activity) {
//        toastContainer = FrameLayout(context).also { container ->
//            val composeView = ComposeView(context).apply {
//                setContent {
//                    ToastList(toasts)
//                }
//            }
//            container.addView(
//                composeView,
//                ViewGroup.LayoutParams(
//                    ViewGroup.LayoutParams.MATCH_PARENT,
//                    ViewGroup.LayoutParams.MATCH_PARENT
//                )
//            )
//
//            val params = WindowManager.LayoutParams().apply {
//                width = WindowManager.LayoutParams.MATCH_PARENT
//                height = WindowManager.LayoutParams.MATCH_PARENT
//                type = WindowManager.LayoutParams.TYPE_APPLICATION_PANEL
//                flags =
//                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
//                format = android.graphics.PixelFormat.TRANSLUCENT
//                gravity = if (toasts.firstOrNull()?.config?.position == PositionToastType.TOP) Gravity.TOP else Gravity.BOTTOM
//            }
//            context.windowManager.addView(container, params)
//        }
//    }
//
//    private fun removeToastContainer(context: Activity) {
//        toastContainer?.let {
//            try {
//                context.windowManager.removeView(it)
//            } catch (_: Exception) {}
//        }
//        toastContainer = null
//    }
//}