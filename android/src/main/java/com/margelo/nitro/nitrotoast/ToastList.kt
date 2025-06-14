package com.margelo.nitro.nitrotoast

import androidx.compose.animation.*
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.runtime.getValue
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.graphics.TransformOrigin

@Composable
fun ToastList(state: ToastListState) {
    val toasts by state.toasts.collectAsState()

    if (toasts.isEmpty()) return

    val position = when (toasts.firstOrNull()?.config?.position) {
        PositionToastType.TOP -> Alignment.TopCenter
        else -> Alignment.BottomCenter
    }

    val transformOrigin = when (toasts.firstOrNull()?.config?.position) {
        PositionToastType.TOP -> TransformOrigin(0.5f, 0f)
        else -> TransformOrigin(0.5f, 1f)
    }

    val exitAnimation = when (toasts.firstOrNull()?.config?.position) {
        PositionToastType.TOP -> slideOutVertically(
            targetOffsetY = { -it }) + shrinkVertically() + fadeOut()

        else -> slideOutVertically(targetOffsetY = { it }) + shrinkVertically() + fadeOut()
    }
    val enterAnimation = when (toasts.firstOrNull()?.config?.position) {
        PositionToastType.TOP -> slideInVertically(
            initialOffsetY = { -it }) + expandVertically(expandFrom = Alignment.Top) + scaleIn(
            transformOrigin = transformOrigin
        ) + fadeIn(initialAlpha = 0.3f)

        else -> slideInVertically(
            initialOffsetY = { it }
        ) + expandVertically() + scaleIn(
            transformOrigin = transformOrigin
        ) + fadeIn(initialAlpha = 0.3f)
    }


    Column(
        verticalArrangement = Arrangement.spacedBy(8.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .fillMaxSize()
            .padding(
                top = WindowInsets.statusBars.asPaddingValues()
                    .calculateTopPadding() + if (position == Alignment.TopCenter) 16.dp else 0.dp,
                bottom = WindowInsets.navigationBars.asPaddingValues()
                    .calculateBottomPadding() + if (position == Alignment.BottomCenter) 16.dp else 0.dp
            )
    ) {
        if (position == Alignment.BottomCenter) {
            Spacer(modifier = Modifier.weight(1f))
        }
        toasts.forEach { toast ->
            key(toast.id) {
                AnimatedVisibility(
                    visible = toast.isVisible,
                    enter = enterAnimation,
                    exit = exitAnimation
                ) {
                    ToastView(toast)
                }
            }
        }
        if (position == Alignment.TopCenter) {
            Spacer(modifier = Modifier.weight(1f))
        }
    }
}