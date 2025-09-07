package com.margelo.nitro.nitrotoast

import androidx.compose.ui.graphics.Color
import androidx.core.graphics.toColorInt

fun String.toColorOrNull(): Color? =
    try {
        Color(this.toColorInt())
    } catch (e: IllegalArgumentException) {
        null // or log error
    }

data class Toast(
    val id: String,
    val message: String,
    val config: NitroToastConfig,
    var offsetX: Float = 0f,
    var isVisible: Boolean = false,
    var isPaused: Boolean = false,
    var isUpdating: Boolean = false,
) {
    val backgroundColor: Color
        get() =
            config.backgroundColor?.toColorOrNull() ?: when (config.type) {
                ToastType.SUCCESS -> Color(0xFF22C55E)
                ToastType.ERROR -> Color(0xFFEF4444)
                ToastType.INFO -> Color(0xFF3B82F6)
                ToastType.WARNING -> Color(0xFFF59E0B)
                ToastType.LOADING -> Color(0xFF6B7280)
                ToastType.DEFAULT -> Color(0xFF6B7280)
            }

    val overlayColor: Color
        get() = if (config.useOverlay) backgroundColor.copy(alpha = 0.08f) else backgroundColor

    val icon: ToastIcon
        get() {
            config.iconUri?.let { return ToastIcon.Image(it) }
            return when (config.type) {
                ToastType.SUCCESS -> ToastIcon.System("checkmark", iconColor)
                ToastType.ERROR -> ToastIcon.System("error", iconColor)
                ToastType.WARNING -> ToastIcon.System("warning", iconColor)
                ToastType.INFO -> ToastIcon.System("info", iconColor)
                ToastType.LOADING -> ToastIcon.Progress(iconColor)
                ToastType.DEFAULT -> ToastIcon.System("bell", iconColor)
            }
        }
    private val iconColor: Color
        get() = if (config.useOverlay) backgroundColor else Color.White

    val title: String
        get() =
            config.title ?: when (config.type) {
                ToastType.SUCCESS -> "Success"
                ToastType.ERROR -> "Error Occurred"
                ToastType.INFO -> "Information"
                ToastType.WARNING -> "Warning"
                ToastType.LOADING -> "Loading..."
                ToastType.DEFAULT -> "Notice"
            }

    val titleColor: Color
        get() = config.titleColor?.toColorOrNull() ?: Color.Black

    val messageColor: Color
        get() = config.messageColor?.toColorOrNull() ?: Color.DarkGray
}
