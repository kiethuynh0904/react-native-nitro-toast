package com.margelo.nitro.nitrotoast

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.Image
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
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.text.font.FontWeight

@Composable
fun ToastView(toast: Toast) {

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 15.dp)
                .shadow(3.dp, RoundedCornerShape(12.dp))
                .background(Color.White, RoundedCornerShape(12.dp))
                .border(0.5.dp, toast.backgroundColor, RoundedCornerShape(12.dp))

        ) {
            // Overlay semi-transparent layer behind content padding
            Box(
                modifier = Modifier
                    .matchParentSize()
                    .background(toast.overlayColor, RoundedCornerShape(12.dp))
            )

            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.padding(vertical = 12.dp, horizontal = 15.dp)
            ) {
                Image(
                    imageVector = toast.icon,
                    contentDescription = null,
                    modifier = Modifier.size(20.dp),
                    alignment = Alignment.Center,
                    colorFilter = ColorFilter.tint(toast.backgroundColor)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Column(modifier = Modifier.weight(1f)) {
                    BasicText(
                        text = toast.title,
                        style = TextStyle(
                            fontSize = 14.sp,
                            fontWeight = FontWeight.SemiBold,
                            color = Color.Black
                        )
                    )
                    BasicText(
                        text = toast.message,
                        style = TextStyle(
                            fontSize = 13.sp,
                            color = Color.Gray
                        )
                    )
                }
            }

    }
}