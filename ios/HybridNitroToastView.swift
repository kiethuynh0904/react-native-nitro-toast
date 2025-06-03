//
//  SwiftUIView.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Foundation
import SwiftUI
import UIKit

class HybridNitroToastView: HybridNitroToastViewSpec {
  var view: UIView = UIView()

//  private let hostingController: UIHostingController<ToastHostView<EmptyView>>
//
//  override init() {
//    self.hostingController = UIHostingController(
//      rootView: ToastHostView {
//        EmptyView()
//      })
//    super.init()
//
//    hostingController.view.backgroundColor = .clear
//    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(hostingController.view)
//
//    NSLayoutConstraint.activate([
//      hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//      hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//      hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//    ])
//  }
}
