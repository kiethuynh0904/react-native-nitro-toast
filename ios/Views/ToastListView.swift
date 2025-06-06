//
//  ToastListView.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/5/25.
//

import SwiftUI

struct ToastListView: View {
  @ObservedObject var manager = ToastManager.shared

  var body: some View {
    VStack {
      if manager.toasts.first?.config.position == .top {
        ForEach($manager.toasts) { $toast in
          ToastView(toast: toast)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
        Spacer()
      } else {
        Spacer()
        ForEach($manager.toasts) { $toast in
          ToastView(toast: toast)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.vertical, 15)
    .allowsHitTesting(false)
  }
}

private struct ToastView: View {
  let toast: Toast

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: toast.iconName)
        .font(.system(size: 20))
        .foregroundColor(toast.backgroundColor)

      VStack(alignment: .leading) {
        Text(toast.title)
          .font(.footnote)
          .fontWeight(.semibold)
        Text(toast.message)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      Spacer(minLength: 0)
    }
    .padding(.vertical, 12)
    .padding(.leading, 15)
    .padding(.trailing, 10)
    .background {
      ZStack {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(Color(.systemBackground))  // solid base background
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(toast.backgroundColor.opacity(0.08))
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .stroke(toast.backgroundColor, lineWidth: 0.5)
      }
      .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
    .padding(.horizontal, 15)
  }
}

#Preview {
    ToastListView()
}
