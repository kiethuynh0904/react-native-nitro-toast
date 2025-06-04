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

  func show(type: NitroToastType, message: String, duration: Double = 2) {
    let toast = Toast(type: type, message: message)
    withAnimation(.bouncy) {
      self.toasts.append(toast)
    }

//    Task {
//      var remaining = duration
//      let interval: TimeInterval = 0.1
//
//      while remaining > 0 {
//        try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
//        if !self.isExpanded {
//          remaining -= interval
//        }
//      }
//
//      self.dismiss(toast)
//    }
  }

  func dismiss(_ toast: Toast) {
    withAnimation(.bouncy) {
      toasts.removeAll { $0.id == toast.id }
    }

    if toasts.isEmpty {
      isExpanded = false
    }
  }
}
