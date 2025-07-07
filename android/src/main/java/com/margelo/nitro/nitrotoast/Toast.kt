package com.margelo.nitro.nitrotoast

import androidx.compose.ui.graphics.Color
import androidx.core.graphics.toColorInt


fun String.toColorOrNull(): Color? {
    return try {
        Color(this.toColorInt())
    } catch (e: IllegalArgumentException) {
        null // or log error
    }
}

data class Toast(
    val id: String,
    val message: String,
    val config: NitroToastConfig,
    var offsetX: Float = 0f,
    var isVisible: Boolean = false,
    var isPaused: Boolean = false,
    var isUpdating: Boolean = false
) {
    val backgroundColor: Color
        get() = config.backgroundColor?.toColorOrNull() ?: when (config.type) {
            AlertToastType.SUCCESS -> Color(0xFF22C55E)
            AlertToastType.ERROR -> Color(0xFFEF4444)
            AlertToastType.INFO -> Color(0xFF3B82F6)
            AlertToastType.WARNING -> Color(0xFFF59E0B)
            AlertToastType.LOADING -> Color(0xFF6B7280)
            AlertToastType.DEFAULT -> Color(0xFF6B7280)
        }

    val overlayColor: Color
        get() = if (config.useOverlay) backgroundColor.copy(alpha = 0.08f) else backgroundColor

    val icon: ToastIcon
        get() {
            config.iconUri?.let { return ToastIcon.Image(it) }
            return when (config.type) {
                AlertToastType.SUCCESS -> ToastIcon.System("checkmark", iconColor)
                AlertToastType.ERROR -> ToastIcon.System("error", iconColor)
                AlertToastType.WARNING -> ToastIcon.System("warning", iconColor)
                AlertToastType.INFO -> ToastIcon.System("info", iconColor)
                AlertToastType.LOADING -> ToastIcon.Progress(iconColor)
                AlertToastType.DEFAULT -> ToastIcon.System("bell", iconColor)
            }
        }
    private val iconColor: Color
        get() = if (config.useOverlay) backgroundColor else Color.White

    val title: String
        get() = config.title ?: when (config.type) {
            AlertToastType.SUCCESS -> "Success"
            AlertToastType.ERROR -> "Error Occurred"
            AlertToastType.INFO -> "Information"
            AlertToastType.WARNING -> "Warning"
            AlertToastType.LOADING -> "Loading..."
            AlertToastType.DEFAULT -> "Notice"
        }


    val titleColor: Color
        get() = config.titleColor?.toColorOrNull() ?: Color.Black

    val messageColor: Color
        get() = config.messageColor?.toColorOrNull() ?: Color.DarkGray
}