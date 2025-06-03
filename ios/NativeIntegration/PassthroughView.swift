//
//  PassthroughView.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Foundation
import UIKit

class PassthroughWindow: UIWindow {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    // Let touches pass through if it's not on a visible toast
    return hitView == self.rootViewController?.view ? nil : hitView
  }
}
