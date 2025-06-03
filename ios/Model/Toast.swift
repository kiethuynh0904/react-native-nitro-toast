//
//  ToastModel.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Foundation

struct Toast: Identifiable, Equatable {
  let id = UUID()
  let type: NitroToastType
  let message: String
}
