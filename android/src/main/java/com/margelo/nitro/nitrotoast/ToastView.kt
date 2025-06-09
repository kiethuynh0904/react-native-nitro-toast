package com.margelo.nitro.nitrotoast

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun ToastView(toast: Toast) {
    Row(
        modifier = Modifier
            .padding(horizontal = 15.dp)
            .background(Color.White, RoundedCornerShape(12.dp))
            .padding(vertical = 12.dp, horizontal = 15.dp)
            .shadow(3.dp, RoundedCornerShape(12.dp)),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = toast.icon,
            contentDescription = null,
            tint = toast.backgroundColor,
            modifier = Modifier.size(20.dp)
        )
        Spacer(modifier = Modifier.width(12.dp))
        Column {
            Text(
                text = toast.title,
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold
            )
            Text(
                text = toast.message,
                fontSize = 12.sp,
                color = Color.Gray
            )
        }
    }
}