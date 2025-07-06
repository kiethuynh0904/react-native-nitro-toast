//
//  ToastListView.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/5/25.
//

import SwiftUI

struct ToastListView: View {
  @ObservedObject var manager = ToastManager.shared

  var body: some View {
    VStack {
      if manager.toasts.first?.config.position == .top {
        ForEach(manager.toasts) { toast in
          ToastRow(
            toast: toast, position: .top,
            onRemove: {
              manager.dismiss(toast.id)
            })
        }
        Spacer()
      } else {
        Spacer()
        ForEach(manager.toasts) { toast in
          ToastRow(
            toast: toast, position: .bottom,
            onRemove: {
              manager.dismiss(toast.id)
            })
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.bottom, 15)
  }
}

private struct ToastRow: View {
  @ObservedObject var toast: Toast
  let position: PositionToastType
  let onRemove: () -> Void

  @State private var offsetY: CGFloat = 0

  var body: some View {
    ToastView(toast: toast)
      .offset(y: offsetY)
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            toast.isPaused = true
            let translation = value.translation.height
            offsetY = position == .top ? min(translation, 0) : max(translation, 0)
          }
          .onEnded { value in
            toast.isPaused = false
            let velocity = value.velocity.height
            let translation = value.translation.height
            let threshold: CGFloat = 30

            let shouldDismiss =
              position == .top
              ? translation < -threshold || velocity < -500
              : translation > threshold || velocity > 500

            if shouldDismiss {
              onRemove()
            } else {
              offsetY = 0
            }
          }
      )
      .transition(.move(edge: position == .top ? .top : .bottom).combined(with: .opacity))
      .scaleEffect(toast.isUpdating ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: toast.isUpdating)
  }
}

private struct ToastView: View {
  @ObservedObject var toast: Toast

  var body: some View {
    HStack(spacing: 12) {
      ToastIconView(toast: toast)

      VStack(alignment: .leading) {
        Text(toast.title)
          .font(.footnote)
          .fontWeight(.semibold)
          .foregroundStyle(toast.titleColor)
        Text(toast.message)
          .font(.caption)
          .foregroundStyle(toast.messageColor)
      }
      Spacer(minLength: 0)
    }
    .padding(.vertical, 12)
    .padding(.leading, 15)
    .padding(.trailing, 10)
    .background {
      ZStack {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(Color(.systemBackground))  // solid base background
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(toast.overlayColor)
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .stroke(toast.backgroundColor, lineWidth: 0.5)
      }
      .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
    .padding(.horizontal, 15)
    // Animate main view scale for update
    
  }
}

