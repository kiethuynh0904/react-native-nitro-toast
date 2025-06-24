package com.margelo.nitro.nitrotoast

import android.graphics.BitmapFactory
import android.util.Log
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.Image
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.BasicText
import androidx.compose.ui.text.TextStyle
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.remember
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.text.font.FontWeight

@Composable
fun ToastView(toast: Toast) {

    val containerModifier = Modifier
        .fillMaxWidth()
        .padding(horizontal = 15.dp)
        .shadow(1.5.dp, RoundedCornerShape(12.dp))
        .background(Color.White, RoundedCornerShape(12.dp))
        .border(0.5.dp, toast.backgroundColor, RoundedCornerShape(12.dp))

    Box(modifier = containerModifier) {
        Box(
            modifier = Modifier
                .matchParentSize()
                .background(toast.overlayColor, RoundedCornerShape(12.dp))
        )

        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(vertical = 12.dp, horizontal = 15.dp)
        ) {
            ToastIcon(toast)

            Spacer(modifier = Modifier.width(12.dp))

            Column(modifier = Modifier.weight(1f)) {
                BasicText(
                    text = toast.title,
                    style = TextStyle(
                        fontSize = 14.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = toast.titleColor
                    )
                )
                BasicText(
                    text = toast.message,
                    style = TextStyle(
                        fontSize = 13.sp,
                        color = toast.messageColor
                    )
                )
            }
        }
    }
}

@Composable
private fun ToastIcon(toast: Toast) {
    val bitmap = remember(toast.config.iconUri) {
        val uri = toast.config.iconUri?.removePrefix("file://")
        try {
            uri?.let { BitmapFactory.decodeFile(it) }
        } catch (e: Exception) {
            Log.e("ToastIcon", "Failed to decode image: $uri", e)
            null
        }
    }

    if (bitmap != null) {
        Image(
            bitmap = bitmap.asImageBitmap(),
            contentDescription = null,
            modifier = Modifier
                .size(20.dp)
                .clip(CircleShape)
        )
    } else {
        Image(
            imageVector = toast.icon,
            contentDescription = null,
            modifier = Modifier.size(20.dp),
            alignment = Alignment.Center,
            colorFilter = ColorFilter.tint(toast.iconColor)
        )
    }
}