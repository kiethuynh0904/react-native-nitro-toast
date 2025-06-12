//
//  Color+Helper.swift
//  boost-boost_privacy
//
//  Created by kiet.huynh on 6/6/25.
//

import SwiftUI

extension Color {
  static func toastColor(named name: String) -> Color {
    Color(name, bundle: ToastAssets.bundle())
  }

  static var toastSuccess = toastColor(named: "ToastSuccess")
  static var toastError = toastColor(named: "ToastError")
  static var toastWarning = toastColor(named: "ToastWarning")
  static var toastInfo = toastColor(named: "ToastInfo")
  static var toastDefault = toastColor(named: "ToastDefault")

  init(_ hex: String) {
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if hexString.hasPrefix("#") {
      hexString.removeFirst()
    }

    var rgbValue: UInt64 = 0
    guard Scanner(string: hexString).scanHexInt64(&rgbValue) else {
      self = .clear  // or .gray as fallback
      return
    }

    switch hexString.count {
    case 6:
      self.init(
        red: Double((rgbValue >> 16) & 0xFF) / 255,
        green: Double((rgbValue >> 8) & 0xFF) / 255,
        blue: Double(rgbValue & 0xFF) / 255
      )
    case 8:
      self.init(
        red: Double((rgbValue >> 16) & 0xFF) / 255,
        green: Double((rgbValue >> 8) & 0xFF) / 255,
        blue: Double(rgbValue & 0xFF) / 255,
        opacity: Double((rgbValue >> 24) & 0xFF) / 255
      )
    default:
      self = .clear
    }
  }
}
