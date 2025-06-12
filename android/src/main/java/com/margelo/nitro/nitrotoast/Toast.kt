package com.margelo.nitro.nitrotoast

import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Error
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Warning
import androidx.compose.ui.graphics.Color


data class Toast(
    val id: String = java.util.UUID.randomUUID().toString(),
    val message: String,
    val config: NitroToastConfig,
    var offsetX: Float = 0f,
    var isVisible: Boolean = false
) {
    val backgroundColor: Color
        get() = when (config.type) {
            AlertToastType.SUCCESS -> Color(0xFF22C55E)
            AlertToastType.ERROR -> Color(0xFFEF4444)
            AlertToastType.INFO -> Color(0xFF3B82F6)
            AlertToastType.WARNING -> Color(0xFFF59E0B)
            AlertToastType.DEFAULT -> Color(0xFF6B7280)
        }


    val overlayColor: Color
        get() = backgroundColor.copy(alpha = 0.08f)

    val icon: ImageVector
        get() = when (config.type) {
            AlertToastType.SUCCESS -> Icons.Filled.CheckCircle
            AlertToastType.ERROR -> Icons.Filled.Error
            AlertToastType.WARNING -> Icons.Filled.Warning
            AlertToastType.INFO -> Icons.Filled.Info
            AlertToastType.DEFAULT -> Icons.Filled.Info
        }

    val title: String
        get() = config.title ?: when (config.type) {
            AlertToastType.SUCCESS -> "Success"
            AlertToastType.ERROR -> "Error Occurred"
            AlertToastType.INFO -> "Information"
            AlertToastType.WARNING -> "Warning"
            AlertToastType.DEFAULT -> ""
        }
}