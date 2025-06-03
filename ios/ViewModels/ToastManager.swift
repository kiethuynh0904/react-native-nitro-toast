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
  var onEmpty: (() -> Void)?

  func show(type: NitroToastType, message: String, duration: Double = 2) {
    let toast = Toast(type: type, message: message)
    withAnimation {
      self.toasts.append(toast)
    }

    Task {
      try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
      self.dismiss(toast)
    }
  }

  func dismiss(_ toast: Toast) {
    if let index = self.toasts.firstIndex(of: toast) {
      _ = withAnimation {
        self.toasts.remove(at: index)
      }
    }

    if toasts.isEmpty {
      onEmpty?()  // 🔸 Trigger cleanup
    }
  }
}
