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
}
