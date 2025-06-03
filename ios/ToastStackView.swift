//
//  ToastHostView.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import SwiftUI

struct ToastStackView: View {
  @ObservedObject var manager = ToastManager.shared

  var body: some View {
    VStack {
      Spacer()
      ForEach(manager.toasts) { toast in
        ToastView(message: toast.message, type: toast.type)
          .transition(.move(edge: .bottom).combined(with: .opacity))
          .padding(.bottom, 4)
      }
    }
    .padding(.bottom, 50)
    .padding(.horizontal, 16)
    .animation(.easeInOut, value: manager.toasts)
    .allowsHitTesting(false)
  }
}
