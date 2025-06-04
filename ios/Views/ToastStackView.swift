//
//  ToastHostView.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import SwiftUI

struct ToastStackView: View {
  @ObservedObject var manager = ToastManager.shared

  var body: some View {
    VStack {
    }
    //    .padding(.bottom, 50)
    //    .padding(.horizontal, 16)
    //    .animation(.easeInOut, value: manager.toasts)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .allowsHitTesting(false)
    .overlay(alignment: .bottom) {
      ToastsView()
    }
  }
}

private struct ToastsView: View {
  //  @Binding var toasts: [Toast]
  @ObservedObject var manager = ToastManager.shared

  //  @State private var isExpanded: Bool = false

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
        ForEach($manager.toasts) { $toast in
          let index =
            (manager.toasts.count - 1)
            - (manager.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0)

          if #available(iOS 17.0, *) {
            ToastView(
              message: toast.message, type: toast.type,
              onRemove: {
                $manager.toasts.delete(toast.id)
              }
            )
            .offset(x: toast.offsetX)
            .gesture(
              DragGesture()
                .onChanged { value in
                  let xOffset = value.translation.width < 0 ? value.translation.width : 0
                  toast.offsetX = xOffset
                }
                .onEnded { value in
                  let xOffset = value.translation.width + (value.velocity.width / 2)

                  if -xOffset > 200 {
                    ///Remove Toast
                    $manager.toasts.delete(toast.id)
                  } else {
                    /// Reset Toast to it's initial Position
                    toast.offsetX = 0
                  }
                }
            )
            .visualEffect { [isExpanded = manager.isExpanded] content, proxy in
              content
                .scaleEffect(isExpanded ? 1 : scale(index), anchor: .bottom)
                .offset(y: isExpanded ? 0 : offsetY(index))
            }
            .zIndex(toast.isDeleting ? 1000 : 0)
            .frame(maxWidth: .infinity)
            .transition(
              .asymmetric(
                insertion: .offset(y: 100),
                removal: .move(edge: .leading)
              )
            )
          } else {
            // Fallback on earlier versions
          }
        }
      }
      .onTapGesture {
        manager.isExpanded.toggle()
      }
    }
    .animation(.bouncy, value: manager.isExpanded)
    .padding(.bottom, 15)
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

extension Binding<[Toast]> {
  func delete(_ id: String) {
    if let toast = first(where: { $0.id == id }) {
      toast.wrappedValue.isDeleting = true
    }
    withAnimation(.bouncy) {
      self.wrappedValue.removeAll(where: { $0.id == id })
    }
  }
}
