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
    ToastManager.shared.show(message: message, config: config)

    if toastWindow != nil {
      return  // already showing, just update state
    }

    let toastHostView = makeToastHostView(for: config)

    let host = UIHostingController(rootView: toastHostView)
    host.view.backgroundColor = .clear

    let toastWindow = PassthroughWindow(frame: UIScreen.main.bounds)
    toastWindow.windowLevel = .alert + 1
    toastWindow.rootViewController = host
    toastWindow.isHidden = false

    self.toastWindow = toastWindow

    // Monitor when all toasts are gone, then clean up the window
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
      return AnyView(ToastListView())
    }
  }
}
