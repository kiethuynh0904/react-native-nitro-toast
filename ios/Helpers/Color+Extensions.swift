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
}
