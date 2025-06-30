package com.margelo.nitro.nitrotoast

import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Error
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Warning
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
    var isPaused: Boolean = false
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

    val iconUri: String?
        get() = config.iconUri

    val icon: ImageVector
        get() = when (config.type) {
            AlertToastType.SUCCESS -> Icons.Filled.CheckCircle
            AlertToastType.ERROR -> Icons.Filled.Error
            AlertToastType.WARNING -> Icons.Filled.Warning
            AlertToastType.INFO -> Icons.Filled.Info
            AlertToastType.LOADING -> Icons.Filled.Info
            AlertToastType.DEFAULT -> Icons.Filled.Info
        }
    val iconColor: Color
        get() = if(!config.useOverlay) Color.White else backgroundColor

    val title: String
        get() = config.title ?: when (config.type) {
            AlertToastType.SUCCESS -> "Success"
            AlertToastType.ERROR -> "Error Occurred"
            AlertToastType.INFO -> "Information"
            AlertToastType.WARNING -> "Warning"
            AlertToastType.LOADING -> "Loading"
            AlertToastType.DEFAULT -> ""
        }


    val titleColor: Color
        get() = config.titleColor?.toColorOrNull() ?: Color.Black

    val messageColor: Color
        get() = config.messageColor?.toColorOrNull() ?: Color.DarkGray
}