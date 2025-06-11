package com.margelo.nitro.nitrotoast

import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
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

    val icon: ImageVector
        get() = when (config.type) {
            AlertToastType.SUCCESS -> Icons.Default.CheckCircle
            AlertToastType.ERROR -> Icons.Default.Close
            AlertToastType.WARNING -> Icons.Default.Warning
            AlertToastType.INFO -> Icons.Default.Info
            AlertToastType.DEFAULT -> Icons.Default.Info
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