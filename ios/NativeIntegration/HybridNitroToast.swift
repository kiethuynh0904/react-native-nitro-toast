//
//  HybridNitroToast.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import SwiftUI
import UIKit

class HybridNitroToast: HybridNitroToastSpec {

  func show(message: String, config: NitroToastConfig) -> String {
    let toastId = UUID().uuidString
    DispatchQueue.main.async {
      self.presentToast(toastId: toastId, message: message, config: config)
    }
    return toastId
  }

  func dismiss(toastId: String) {
    DispatchQueue.main.async {
      ToastManager.shared.dismiss(toastId)
    }
  }

  @MainActor private func presentToast(toastId: String, message: String, config: NitroToastConfig) {

    /// If the window already exists, just update the toast content
    guard ToastManager.shared.toastWindow == nil else {
      ToastManager.shared.show(toastId: toastId, message: message, config: config)
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
    ToastManager.shared.toastWindow = toastWindow

    /// Show toast after UI is attached
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      ToastManager.shared.show(toastId: toastId, message: message, config: config)
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
