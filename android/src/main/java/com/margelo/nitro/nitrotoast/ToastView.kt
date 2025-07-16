package com.margelo.nitro.nitrotoast

import android.graphics.BitmapFactory
import android.util.Log
import androidx.compose.animation.Crossfade
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun toastView(toast: Toast) {
//    val scale by animateFloatAsState(if (toast.isUpdating) 1.05f else 1.0f)

    // Animate overlayColor
    val animatedOverlayColor by animateColorAsState(targetValue = toast.overlayColor, label = "overlayColor")

    val containerModifier =
        Modifier
            .fillMaxWidth()
            .padding(horizontal = 15.dp)
            .shadow(1.5.dp, RoundedCornerShape(12.dp))
            .background(Color.White, RoundedCornerShape(12.dp))
            .border(0.5.dp, toast.backgroundColor, RoundedCornerShape(12.dp))

    Box(modifier = containerModifier) {
        Box(
            modifier =
                Modifier
                    .matchParentSize()
                    .background(animatedOverlayColor, RoundedCornerShape(12.dp)),
        )

        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(vertical = 12.dp, horizontal = 15.dp),
        ) {
            renderToastIcon(toast)

            Spacer(modifier = Modifier.width(12.dp))

            Column(modifier = Modifier.weight(1f)) {
                Crossfade(
                    targetState = toast.title,
                    label = "toastTitle",
                ) { title ->
                    BasicText(
                        text = title,
                        style =
                            TextStyle(
                                fontSize = 14.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = toast.titleColor,
                            ),
                    )
                }
                Crossfade(
                    targetState = toast.message,
                    label = "toastMessage",
                ) { message ->
                    BasicText(
                        text = message,
                        style =
                            TextStyle(
                                fontSize = 13.sp,
                                color = toast.messageColor,
                            ),
                    )
                }
            }
        }
    }
}

/**
 * Renders the icon for the toast, based on a sealed ToastIcon model.
 */
@Composable
private fun renderToastIcon(toast: Toast) {
    Crossfade(targetState = toast.icon, label = "toastIcon") { icon ->
        when (icon) {
            is ToastIcon.Progress -> {
                spinner(color = icon.color)
            }
            is ToastIcon.Image -> {
                val bitmap =
                    remember(icon.uri) {
                        val uri = icon.uri.removePrefix("file://")
                        try {
                            BitmapFactory.decodeFile(uri)
                        } catch (e: Exception) {
                            Log.e("ToastIcon", "Failed to decode image: $uri", e)
                            null
                        }
                    }
                if (bitmap != null) {
                    Image(
                        bitmap = bitmap.asImageBitmap(),
                        contentDescription = null,
                        modifier =
                            Modifier
                                .size(20.dp)
                                .clip(CircleShape),
                    )
                }
            }
            is ToastIcon.System -> {
                val imageVector: ImageVector? =
                    resolveSystemIcon(icon.name)
                imageVector?.let {
                    Image(
                        imageVector = it,
                        contentDescription = null,
                        modifier = Modifier.size(20.dp),
                        alignment = Alignment.Center,
                        colorFilter = ColorFilter.tint(icon.color),
                    )
                }
            }
        }
    }
}

@Composable
fun spinner(
    color: Color,
    size: Dp = 20.dp,
) {
    val infiniteTransition = rememberInfiniteTransition(label = "spinner")
    val angle by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec =
            infiniteRepeatable(
                animation = tween(durationMillis = 1000),
                repeatMode = RepeatMode.Restart,
            ),
        label = "angle",
    )

    Canvas(modifier = Modifier.size(size)) {
        val stroke = Stroke(width = 2.dp.toPx())
        drawArc(
            color = color,
            startAngle = angle,
            sweepAngle = 270f,
            useCenter = false,
            style = stroke,
        )
    }
}
