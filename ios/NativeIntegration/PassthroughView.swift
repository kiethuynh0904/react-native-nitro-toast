//
//  PassthroughView.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Foundation
import UIKit
/// UIWindow subclass that lets touches pass through transparent areas.
///
/// Touches outside visible toast views pass to underlying views,
/// so the toast window doesn’t block interaction.
///
/// Helps ensure touch events work correctly when integrating with React Native.
class PassthroughWindow: UIWindow {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    // Let touches pass through if it's not on a visible toast
    return hitView == self.rootViewController?.view ? nil : hitView
  }
}
