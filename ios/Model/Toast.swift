//
//  ToastModel.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Foundation

struct Toast: Identifiable, Equatable {
  let id = UUID().uuidString
  let type: NitroToastType
  let message: String

  /// View Properties
  var offsetX: CGFloat = 0
  var isDeleting: Bool = false
}
