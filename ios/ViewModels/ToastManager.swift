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

  /// MARK: Published State
  @Published var toasts: [Toast] = []
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

  func present(toastId: String, message: String, config: NitroToastConfig) {
    /// If the window already exists, just update the toast content
    guard toastWindow == nil else {
      self.show(toastId: toastId, message: message, config: config)
      return
    }

    /// Create and configure the hosting controller
    let toastHostView = makeToastView(for: config)
    let host = UIHostingController(rootView: toastHostView)
    host.view.backgroundColor = .clear

    /// Create and present the toast window
    let window = PassthroughWindow(frame: UIScreen.main.bounds)
    window.windowLevel = .alert + 1
    window.rootViewController = host
    window.isHidden = false
    self.toastWindow = window

    /// Show toast after UI is attached
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      self.show(toastId: toastId, message: message, config: config)
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

  private func cleanWindow() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      guard self.isEmpty else { return }
      self.toastWindow?.isHidden = true
      self.toastWindow?.rootViewController = nil
      self.toastWindow = nil
    }
  }

  private func makeToastView(for config: NitroToastConfig) -> some View {
    switch config.presentation {
    case .stacked: return AnyView(ToastStackView())
    case .alert: return AnyView(ToastListView())
    }
  }

  private func triggerHaptics(for type: AlertToastType?) {
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
