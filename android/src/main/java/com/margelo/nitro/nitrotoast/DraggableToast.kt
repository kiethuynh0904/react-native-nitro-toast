package com.margelo.nitro.nitrotoast

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.core.EaseInOut
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.shrinkVertically
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.gestures.detectVerticalDragGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.offset
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.TransformOrigin
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.unit.IntOffset

@Composable
fun draggableToast(
    toast: Toast,
    position: Alignment,
    onPaused: (Boolean) -> Unit,
    onDismiss: () -> Unit,
) {
    var offsetY by remember { mutableFloatStateOf(0f) }
    val animatedOffsetY by animateFloatAsState(
        targetValue = offsetY,
        animationSpec =
            spring(
                dampingRatio = Spring.DampingRatioLowBouncy,
                stiffness = Spring.StiffnessLow,
            ),
        label = "offsetY",
    )
    val scale by animateFloatAsState(
        targetValue = if (toast.isUpdating) 1.05f else 1.0f,
        animationSpec = tween(durationMillis = 300, easing = EaseInOut),
        label = "scale",
    )
    val enterAnimation = getEnterAnimation(position)
    val exitAnimation = getExitAnimation(position)

    AnimatedVisibility(
        visible = toast.isVisible,
        enter = enterAnimation,
        exit = exitAnimation,
    ) {
        Box(
            modifier =
                Modifier
                    .offset { IntOffset(0, animatedOffsetY.toInt()) }
                    .pointerInput(Unit) {
                        detectVerticalDragGestures(
                            onDragStart = {
//                            onPaused(true)
                            },
                            onVerticalDrag = { _, dragAmount ->
                                offsetY += dragAmount
                                offsetY =
                                    when (toast.config.position) {
                                        PositionToastType.TOP -> minOf(offsetY, 0f)
                                        PositionToastType.BOTTOM -> maxOf(offsetY, 0f)
                                    }
                            },
                            onDragEnd = {
//                            onPaused(false)
                                val threshold = 50f
                                val shouldDismiss =
                                    when (toast.config.position) {
                                        PositionToastType.TOP -> offsetY < -threshold
                                        PositionToastType.BOTTOM -> offsetY > threshold
                                    }
                                if (shouldDismiss) {
                                    onDismiss()
                                } else {
                                    offsetY = 0f
                                }
                            },
                        )
                    }.graphicsLayer(scaleX = scale, scaleY = scale),
        ) {
            toastView(toast)
        }
    }
}

@Composable
private fun getEnterAnimation(position: Alignment): EnterTransition {
    val transformOrigin =
        if (position == Alignment.TopCenter) {
            TransformOrigin(0.5f, 0f)
        } else {
            TransformOrigin(0.5f, 1f)
        }

    return if (position == Alignment.TopCenter) {
        slideInVertically(initialOffsetY = { -it }) +
            expandVertically(expandFrom = Alignment.Top) +
            scaleIn(transformOrigin = transformOrigin) +
            fadeIn(initialAlpha = 0.3f)
    } else {
        slideInVertically(initialOffsetY = { it }) +
            expandVertically() +
            scaleIn(transformOrigin = transformOrigin) +
            fadeIn(initialAlpha = 0.3f)
    }
}

@Composable
private fun getExitAnimation(position: Alignment): ExitTransition =
    if (position == Alignment.TopCenter) {
        slideOutVertically(targetOffsetY = { -it }) + shrinkVertically() + fadeOut()
    } else {
        slideOutVertically(targetOffsetY = { it }) + shrinkVertically() + fadeOut()
    }
