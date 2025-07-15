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
        let toastId = config.toastId ?? UUID().uuidString
        DispatchQueue.main.async {
            ToastViewModel.shared.present(toastId: toastId, message: message, config: config)
        }
        return toastId
    }

    func dismiss(toastId: String) {
        DispatchQueue.main.async {
            ToastViewModel.shared.dismiss(toastId)
        }
    }
}
