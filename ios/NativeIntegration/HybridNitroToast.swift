//
//  HybridNitroToast.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import SwiftUI
import UIKit

class HybridNitroToast: HybridNitroToastSpec {

  static let shared = HybridNitroToast()
  private var toastWindow: UIWindow?

  func show(message: String, config: NitroToastConfig) {
    DispatchQueue.main.async {
      self.presentToast(message: message, config: config)
    }
  }
  @MainActor private func presentToast(message: String, config: NitroToastConfig) {

    /// If the window already exists, just update the toast content
    guard toastWindow == nil else {
      ToastManager.shared.show(message: message, config: config)
      return
    }

    /// Create and configure the hosting controller
    let toastHostView = makeToastHostView(for: config)
    let host = UIHostingController(rootView: toastHostView)
    host.view.backgroundColor = .clear

    /// Create and present the toast window
    let toastWindow = PassthroughWindow(frame: UIScreen.main.bounds)
    toastWindow.windowLevel = .alert + 1
    toastWindow.rootViewController = host
    toastWindow.isHidden = false
    self.toastWindow = toastWindow

    /// Show toast after UI is attached
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      ToastManager.shared.show(message: message, config: config)
    }

    /// Clean up the window when all toasts are gone
    ToastManager.shared.onEmpty = { [weak self] in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self?.toastWindow?.isHidden = true
        self?.toastWindow?.rootViewController = nil
        self?.toastWindow = nil
      }
    }
  }

  private func makeToastHostView(for config: NitroToastConfig) -> AnyView {
    switch config.presentation {
    case .stacked:
      return AnyView(ToastStackView())
    case .alert:
      return AnyView(
        ToastListView()
      )
    }
  }
}
