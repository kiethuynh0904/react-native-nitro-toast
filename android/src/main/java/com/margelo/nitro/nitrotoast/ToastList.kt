package com.margelo.nitro.nitrotoast

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun toastList(state: ToastListState) {
    val toasts by state.toasts.collectAsState()

    if (toasts.isEmpty()) return

    val position =
        when (toasts.firstOrNull()?.config?.position) {
            PositionToastType.TOP -> Alignment.TopCenter
            else -> Alignment.BottomCenter
        }

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
                            if (position == Alignment.TopCenter) 16.dp else 0.dp,
                    bottom =
                        WindowInsets.navigationBars
                            .asPaddingValues()
                            .calculateBottomPadding() +
                            if (position == Alignment.BottomCenter) 16.dp else 0.dp,
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
