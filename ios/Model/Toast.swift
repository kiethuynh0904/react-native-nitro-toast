//
//  ToastModel.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Foundation
import SwiftUI

enum ToastIcon {
  case system(name: String, color: Color)
  case image(uri: String)
  case progress(color: Color)
  case none
}

final class Toast: Identifiable, ObservableObject {
  var id: String
  @Published var message: String
  @Published var config: NitroToastConfig

  /// View Properties
    @Published var isUpdating: Bool = false
  @Published var isPaused: Bool = false
  @Published var isDeleting: Bool = false

  init(toastId: String, message: String, config: NitroToastConfig) {
    self.id = toastId
    self.message = message
    self.config = config
  }
}

extension NitroToastConfig: Equatable {
  public static func == (lhs: NitroToastConfig, rhs: NitroToastConfig) -> Bool {
    return lhs.presentation == rhs.presentation && lhs.type == rhs.type
  }
}

extension Toast {
  var backgroundColor: Color {
    if let hex = config.backgroundColor {
      return Color(hex)
    }

    switch config.type {
    case .success:
      return Color.toastSuccess
    case .error:
      return Color.toastError
    case .info:
      return Color.toastInfo
    case .warning:
      return Color.toastWarning
    case .loading:
      return Color.toastDefault
    case .default:
      return Color.toastDefault
    }
  }

  var overlayColor: Color {
    if config.useOverlay {
      return self.backgroundColor.opacity(0.08)
    }
    return self.backgroundColor
  }

  var icon: ToastIcon {
    if let uri = config.iconUri {
      return .image(uri: uri)
    }

    switch config.type {
    case .success:
      return .system(name: "checkmark.circle", color: iconColor)
    case .error:
      return .system(name: "exclamationmark.circle", color: iconColor)
    case .info:
      return .system(name: "info.circle", color: iconColor)
    case .warning:
      return .system(name: "exclamationmark.triangle", color: iconColor)
    case .loading:
      return .progress(color: iconColor)
    case .default:
      return .system(name: "bell", color: iconColor)
    }
  }
  var iconColor: Color {
    if config.useOverlay {
      return self.backgroundColor
    }
    return .white
  }

  var title: String {
    if let title = config.title {
      return title
    }
    switch config.type {
    case .success:
      return "Success"
    case .error:
      return "Error Occurred"
    case .info:
      return "Information"
    case .warning:
      return "Warning"
    case .loading:
      return "Loading..."
    case .default:
      return "Notice"
    }
  }

  var titleColor: Color {
    if let hex = config.titleColor {
      return Color(hex)
    }
    return .black
  }

  var messageColor: Color {
    if let hex = config.messageColor {
      return Color(hex)
    }
    return .secondary
  }
}
