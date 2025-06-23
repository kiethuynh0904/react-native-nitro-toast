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
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    if #available(iOS 18, *) {
      guard let root = rootViewController?.view else { return false }
      let hit = Self._hitTest(point, with: event, in: subviews.count > 1 ? self : root)
      return hit != nil
    }
    return super.point(inside: point, with: event)
  }
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if #available(iOS 18, *) {
      return super.hitTest(point, with: event)
    }
    let hit = super.hitTest(point, with: event)
    return (hit == rootViewController?.view) ? nil : hit
  }
  private static func _hitTest(
    _ point: CGPoint,
    with event: UIEvent?,
    in view: UIView,
    depth: Int = 0
  ) -> (view: UIView, depth: Int)? {
    var best: (view: UIView, depth: Int)?
    for sub in view.subviews.reversed() {
      let pt = view.convert(point, to: sub)
      guard sub.isUserInteractionEnabled, !sub.isHidden, sub.alpha > 0,
            sub.point(inside: pt, with: event) else { continue }
      if let deeper = _hitTest(pt, with: event, in: sub, depth: depth + 1) {
        if best == nil || deeper.depth > best!.depth { best = deeper }
      } else {
        if best == nil || depth > best!.depth { best = (sub, depth) }
      }
    }
    return best
  }
}







