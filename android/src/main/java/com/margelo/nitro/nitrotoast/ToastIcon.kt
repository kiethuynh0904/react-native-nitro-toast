package com.margelo.nitro.nitrotoast

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Error
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Warning
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector


fun resolveSystemIcon(name: String): ImageVector? {
    return when (name) {
        "checkmark" -> Icons.Filled.CheckCircle
        "error" -> Icons.Filled.Error
        "warning" -> Icons.Filled.Warning
        "info" -> Icons.Filled.Info
        "bell" -> Icons.Filled.Notifications
        else -> null
    }
}

sealed class ToastIcon {
    data class System(val name: String, val color: Color) : ToastIcon()
    data class Image(val uri: String) : ToastIcon()
    data class Progress(val color: Color) : ToastIcon()
}