
import UIKit
import SwiftUI

class HybridNitroToast:HybridNitroToastSpec {
    
    static let shared = HybridNitroToast()
      private var toastWindow: UIWindow?
      private var toastVC: UIHostingController<ToastView>?
    
    func show (message:String, type: NitroToastType) {
        DispatchQueue.main.async {
            let toastView = ToastView(type: type, message: message)
            let controller = UIHostingController(rootView: toastView)
            controller.view.backgroundColor = .clear
            controller.view.isUserInteractionEnabled = false
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
            
            keyWindow.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor),
                controller.view.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            self.toastVC = controller
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.dismiss()
            }
        }
    }
    private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
          self.toastVC?.view.alpha = 0
        }, completion: { _ in
          self.toastVC?.view.removeFromSuperview()
          self.toastVC = nil
        })
      }
}
