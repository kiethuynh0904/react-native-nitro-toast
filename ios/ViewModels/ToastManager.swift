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
  var toastWindow: UIWindow?

  var isEmpty: Bool { toasts.isEmpty }

  @Published var toasts: [Toast] = []

  ///Toast stack props
  @Published var isExpanded: Bool = false

  func show(toastId: String, message: String, config: NitroToastConfig) {
    let toast = Toast(toastId: toastId, message: message, config: config)

    if config.haptics == true {
      triggerHaptics(for: config.type)
    }
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
        if !self.isExpanded && !toast.isPaused {
          remaining -= interval
        }
      }

      self.dismiss(toast.id)
    }
  }

  func dismiss(_ toastId: String) {
    guard let index = toasts.firstIndex(where: { $0.id == toastId }) else { return }
    toasts[index].isDeleting = true

    withAnimation(.bouncy) {
      toasts.removeAll { $0.id == toastId }
    }

    if isEmpty {
      isExpanded = false
      cleanWindow()
    }
  }

  func cleanWindow() {
    /// Clean up the window when all toasts are gone
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      guard self.isEmpty else { return }
      self.toastWindow?.isHidden = true
      self.toastWindow?.rootViewController = nil
      self.toastWindow = nil
    }
  }

  func triggerHaptics(for type: AlertToastType?) {
    let generator = UINotificationFeedbackGenerator()
    switch type {
    case .success:
      generator.notificationOccurred(.success)
    case .error:
      generator.notificationOccurred(.error)
    case .warning:
      generator.notificationOccurred(.warning)
    default:
      let light = UIImpactFeedbackGenerator(style: .light)
      light.impactOccurred()
    }
  }
}
