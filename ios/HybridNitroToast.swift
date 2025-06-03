import SwiftUI
import UIKit

class HybridNitroToast: HybridNitroToastSpec {

  static let shared = HybridNitroToast()
  private var toastWindow: UIWindow?

  @objc public func show(message: String, type: NitroToastType) {
    DispatchQueue.main.async {
      self.presentToast(message: message, type: type)
    }
  }
  @MainActor private func presentToast(message: String, type: NitroToastType) {
    ToastManager.shared.show(type: type, message: message)

    if toastWindow != nil {
      return  // already showing, just update state
    }

    let toastStackView = ToastStackView()
    let host = UIHostingController(rootView: toastStackView)
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
}

class PassthroughWindow: UIWindow {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    // Let touches pass through if it's not on a visible toast
    return hitView == self.rootViewController?.view ? nil : hitView
  }
}
