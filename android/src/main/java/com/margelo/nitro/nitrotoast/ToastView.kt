package com.margelo.nitro.nitrotoast

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun ToastView(toast: Toast) {
    Surface(
        tonalElevation = 6.dp,
        shadowElevation = 4.dp,
        shape = MaterialTheme.shapes.medium
    ) {
        Box(
            modifier = Modifier
                .background(Color.DarkGray)
                .padding(horizontal = 16.dp, vertical = 12.dp)
        ) {
            Text(toast.message, color = Color.White, fontSize = 14.sp)
        }
    }
}