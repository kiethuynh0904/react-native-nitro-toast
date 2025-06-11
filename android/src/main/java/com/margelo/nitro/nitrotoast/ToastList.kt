package com.margelo.nitro.nitrotoast

import androidx.compose.animation.*
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.runtime.getValue
import androidx.compose.runtime.collectAsState

@Composable
fun ToastList(state: ToastListState) {
    val toasts by state.toasts.collectAsState()

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
        Column(
            verticalArrangement = Arrangement.spacedBy(8.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.wrapContentHeight()
        ) {
            toasts.forEach { toast ->
                key(toast.id) {
                    AnimatedVisibility(
                        visible = toast.isVisible,
                        enter = slideInVertically(initialOffsetY = { it }) + fadeIn(),
                        exit = slideOutVertically(targetOffsetY = { it }) + fadeOut()
                    ) {
                        ToastView(toast)
                    }
                }
            }
        }
    }
}