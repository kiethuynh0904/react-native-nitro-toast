package com.margelo.nitro.nitrotoast

import androidx.compose.animation.*
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun ToastList(toasts: List<Toast>) {
    if (toasts.isEmpty()) return

    val position = when (toasts.firstOrNull()?.config?.position) {
        PositionToastType.TOP -> Alignment.TopCenter
        else -> Alignment.BottomCenter
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(vertical = 15.dp),
        contentAlignment = position
    ) {
        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            toasts.forEach { toast ->
                key(toast.id) {
                    AnimatedVisibility(
                        visible = true,
                        enter = slideInVertically(
                            initialOffsetY = { if (position == Alignment.TopCenter) -it else it }
                        ) + fadeIn(),
                        exit = slideOutVertically(
                            targetOffsetY = { if (position == Alignment.TopCenter) -it else it }
                        ) + fadeOut()
                    ) {
                        ToastView(toast)
                    }
                }
            }
        }
    }
}