package com.margelo.nitro.nitrotoast

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.unit.dp

@Composable
fun toastList(state: ToastListState) {
    val toasts by state.toasts.collectAsState()

    if (toasts.isEmpty()) return

    // Stacked presentation: collapsed deck that expands on tap (parity with iOS).
    if (toasts.firstOrNull()?.config?.presentation == PresentationToastType.STACKED) {
        stackedToastList(state)
        return
    }

    val position =
        when (toasts.firstOrNull()?.config?.position) {
            PositionToastType.TOP -> Alignment.TopCenter
            else -> Alignment.BottomCenter
        }

    val offset = (toasts.firstOrNull()?.config?.offset ?: 0.0).dp

    Column(
        verticalArrangement = Arrangement.spacedBy(8.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier =
            Modifier
                .fillMaxSize()
                .padding(
                    top =
                        WindowInsets.statusBars
                            .asPaddingValues()
                            .calculateTopPadding() +
                            if (position == Alignment.TopCenter) 16.dp + offset else 0.dp,
                    bottom =
                        WindowInsets.navigationBars
                            .asPaddingValues()
                            .calculateBottomPadding() +
                            if (position == Alignment.BottomCenter) 16.dp + offset else 0.dp,
                ),
    ) {
        if (position == Alignment.BottomCenter) {
            Spacer(modifier = Modifier.weight(1f))
        }

        toasts.forEach { toast ->
            key(toast.id) {
                draggableToast(
                    toast = toast,
                    position = position,
                    onPaused = {
                        state.setPaused(toast.id, it)
                    },
                    onDismiss = {
                        ToastManager.dismiss(toast.id)
                    },
                )
            }
        }

        if (position == Alignment.TopCenter) {
            Spacer(modifier = Modifier.weight(1f))
        }
    }
}

/**
 * Stacked presentation: a bottom-anchored deck. Collapsed, the newest toast sits in
 * front and older ones peek scaled-down behind it; tapping expands into a vertical
 * list (with a dim scrim). Mirrors iOS `ToastStackView`. Blur backdrop is API 31+ only,
 * so a dim scrim is used for parity across versions.
 */
@Composable
fun stackedToastList(state: ToastListState) {
    val toasts by state.toasts.collectAsState()
    val isExpanded by state.isExpanded.collectAsState()

    if (toasts.isEmpty()) return

    val offset = (toasts.firstOrNull()?.config?.offset ?: 0.0).dp
    val scrimAlpha by animateFloatAsState(
        targetValue = if (isExpanded) 0.25f else 0f,
        label = "scrim",
    )

    Box(modifier = Modifier.fillMaxSize()) {
        // Dim backdrop while expanded; tap to collapse.
        if (scrimAlpha > 0f) {
            Box(
                modifier =
                    Modifier
                        .fillMaxSize()
                        .background(Color.Black.copy(alpha = scrimAlpha))
                        .pointerInput(Unit) {
                            detectTapGestures { state.setExpanded(false) }
                        },
            )
        }

        Box(
            modifier =
                Modifier
                    .align(Alignment.BottomCenter)
                    .navigationBarsPadding()
                    .padding(bottom = 16.dp + offset),
            contentAlignment = Alignment.BottomCenter,
        ) {
            if (isExpanded) {
                Column(
                    verticalArrangement = Arrangement.spacedBy(10.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                ) {
                    toasts.forEach { toast ->
                        key(toast.id) {
                            draggableToast(
                                toast = toast,
                                position = Alignment.BottomCenter,
                                onPaused = { state.setPaused(toast.id, it) },
                                onDismiss = { ToastManager.dismiss(toast.id) },
                            )
                        }
                    }
                }
            } else {
                // Collapsed deck — tap anywhere on it to expand.
                Box(
                    modifier =
                        Modifier.pointerInput(Unit) {
                            detectTapGestures { state.setExpanded(true) }
                        },
                    contentAlignment = Alignment.BottomCenter,
                ) {
                    toasts.forEachIndexed { index, toast ->
                        // depth 0 = newest (front), larger depth = further back.
                        val depth = (toasts.lastIndex - index).coerceAtMost(2)
                        val scale by animateFloatAsState(
                            targetValue = 1f - depth * 0.06f,
                            label = "deckScale",
                        )
                        val translateY by animateFloatAsState(
                            targetValue = -depth * 14f,
                            label = "deckOffset",
                        )
                        key(toast.id) {
                            Box(
                                modifier =
                                    Modifier.graphicsLayer {
                                        scaleX = scale
                                        scaleY = scale
                                        translationY = translateY
                                    },
                            ) {
                                toastView(toast)
                            }
                        }
                    }
                }
            }
        }
    }
}
