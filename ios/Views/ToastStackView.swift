//
//  ToastStackView.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import SwiftUI

struct ToastStackView: View {
  @ObservedObject var manager = ToastManager.shared

  var body: some View {
    ZStack(alignment: .bottom) {
      Color.clear
      ToastsView(manager: manager)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .allowsTightening(false)
  }
}

private struct ToastsView: View {
  @ObservedObject var manager: ToastManager

  var body: some View {
    ZStack(alignment: .bottom) {
      if manager.isExpanded {
        Rectangle()
          .fill(.ultraThinMaterial)
          .ignoresSafeArea()
          .onTapGesture {
            manager.isExpanded = false
          }
      }
      let layout =
        manager.isExpanded ? AnyLayout(VStackLayout(spacing: 10)) : AnyLayout(ZStackLayout())
      layout {
        ForEach(Array(manager.toasts.enumerated()), id: \.element.id) { idx, toast in
          let index = manager.toasts.count - 1 - idx
          let yOffset = offsetY(index)
          let scale = scale(index)

          ToastRow(toast: toast, offsetY: yOffset, scale: scale, isExpanded: manager.isExpanded) {
            manager.dismiss(toast.id)
          }
          .zIndex(Double(idx))
        }
      }
      .onTapGesture {
        manager.isExpanded.toggle()
      }
      .padding(.bottom, 15)
    }
    .animation(.bouncy, value: manager.isExpanded)
    .onChange(of: manager.toasts.isEmpty) { newValue in
      if newValue {
        manager.isExpanded = false
      }
    }
  }

  nonisolated func offsetY(_ index: Int) -> CGFloat {
    let offset = min(CGFloat(index) * 15, 30)
    return -offset
  }

  nonisolated func scale(_ index: Int) -> CGFloat {
    let scale = min(CGFloat(index) * 0.1, 1)
    return 1 - scale
  }
}

private struct ToastRow: View {
  let toast: Toast
  let offsetY: CGFloat
  let scale: CGFloat
  let isExpanded: Bool
  let onRemove: () -> Void

  @State private var offsetX: CGFloat = 0

  var body: some View {
    if #available(iOS 17.0, *) {
      ToastView(toast: toast, onRemove: onRemove)
        .offset(x: offsetX)
        .gesture(
          DragGesture()
            .onChanged { value in
              offsetX = min(value.translation.width, 0)
            }
            .onEnded { value in
              let predicted = value.translation.width + (value.velocity.width / 2)
              if -predicted > 200 {
                onRemove()
              } else {
                offsetX = 0
              }
            }
        )
        .visualEffect { [isExpanded] content, proxy in
          content
            .scaleEffect(isExpanded ? 1 : scale, anchor: .bottom)
            .offset(y: isExpanded ? 0 : offsetY)
        }
        .frame(maxWidth: .infinity)
        .transition(
          .asymmetric(
            insertion: .offset(y: 100),
            removal: .move(edge: .leading)
          )
        )
    } else {
      ToastView(toast: toast, onRemove: onRemove)
        .offset(x: offsetX)
        .gesture(
          DragGesture()
            .onChanged { value in
              offsetX = min(value.translation.width, 0)
            }
            .onEnded { value in
              let predicted = value.translation.width + (value.velocity.width / 2)
              if -predicted > 200 {
                onRemove()
              } else {
                offsetX = 0
              }
            }
        )
        .scaleEffect(isExpanded ? 1 : scale, anchor: .bottom)
        .offset(y: isExpanded ? 0 : offsetY)
        .zIndex(toast.isDeleting ? 1000 : 0)
        .frame(maxWidth: .infinity)
        .transition(
          .asymmetric(
            insertion: .offset(y: 100),
            removal: .move(edge: .leading)
          )
        )
    }
  }
}

private struct ToastView: View {
  let toast: Toast
  let onRemove: () -> Void

  var body: some View {
    HStack(spacing: 12) {
      ToastIconView(toast: toast)
      Text(toast.message)
        .font(.footnote)
      Spacer(minLength: 0)

      Button {
        onRemove()
      } label: {
        Image(systemName: "xmark.circle.fill")
          .font(.title2)
      }
    }
    .foregroundStyle(Color.primary)
    .padding(.vertical, 12)
    .padding(.leading, 15)
    .padding(.trailing, 10)
    .background {
      Capsule()
        .fill(.background)
        /// Shadows
        .shadow(color: .black.opacity(0.06), radius: 3, x: -1, y: -3)
        .shadow(color: .black.opacity(0.06), radius: 2, x: 1, y: 3)

    }
    .padding(.horizontal, 15)
  }
}
