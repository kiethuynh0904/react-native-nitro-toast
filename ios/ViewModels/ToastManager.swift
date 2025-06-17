//
//  ToastManager.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Combine
import SwiftUI

@MainActor
class ToastManager: ObservableObject {
  static let shared = ToastManager()

  @Published var toasts: [Toast] = []
  @Published var isExpanded: Bool = false

  var onEmpty: (() -> Void)?

  func show(message: String, config: NitroToastConfig) {
    let toast = Toast(message: message, config: config)
    withAnimation(.bouncy) {
      self.toasts.append(toast)
    }

    guard config.duration > 0 else { return }

    Task {
      /// Auto dismiss
      var remaining = config.duration / 1000
      let interval: TimeInterval = 0.1

      while remaining > 0 {
        try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
        if !self.isExpanded {
          remaining -= interval
        }
      }

      self.dismiss(toast)
    }
  }

  func dismiss(_ toast: Toast) {
    withAnimation(.bouncy) {
      toasts.removeAll { $0.id == toast.id }
    }

    if toasts.isEmpty {
      onEmpty?()
      isExpanded = false
    }
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
