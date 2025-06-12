//
//  ToastModel.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Foundation
import SwiftUI

struct Toast: Identifiable, Equatable {
  let id = UUID().uuidString
  let message: String
  let config: NitroToastConfig

  /// View Properties
  var offsetX: CGFloat = 0
  var isDeleting: Bool = false
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

  var iconName: String {
    switch config.type {
    case .success:
      return "checkmark.circle.fill"
    case .error:
      return "exclamationmark.triangle.fill"
    case .info:
      return "info.circle.fill"
    case .warning:
      return "exclamationmark.circle.fill"
    case .default:
      return "bell.fill"
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
    case .default:
      return ""
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
