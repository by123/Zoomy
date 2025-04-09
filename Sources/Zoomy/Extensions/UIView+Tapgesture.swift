//
//  UIView+Tapgesture.swift
//  Artguru
//
//  Created by by on 2025/4/9.
//  Copyright © 2025 Mobiuspace. All rights reserved.
//

import Foundation
import UIKit

private var gestureKey: Void?

extension UIView {

  public typealias LongPressGestureBlock = (
    _ sender: UIView, _ gesture: UILongPressGestureRecognizer
  ) -> Void
  public func addLongPressAction(
    shouldAnimation: Bool = false,
    tapBlock: @escaping LongPressGestureBlock
  ) {
    self.longPressBlock = tapBlock
    isUserInteractionEnabled = true
    let tapGesture = UILongPressGestureRecognizer.init(
      target: self,
      action: #selector(onLongPress(sender:)))
    tapGesture.minimumPressDuration = 0.1
    addGestureRecognizer(tapGesture)
  }

  @objc private func onLongPress(
    sender: UILongPressGestureRecognizer
  ) {
    if let notNilTabBlock = self.longPressBlock {
      if sender.state == .began {
        notNilTabBlock(self, sender)
      } else if sender.state == .ended {
        notNilTabBlock(self, sender)
      }
    }
  }

  private var longPressBlock: LongPressGestureBlock? {
    set {
      objc_setAssociatedObject(
        self, &gestureKey, newValue, .OBJC_ASSOCIATION_COPY)
    }
    get {
      return objc_getAssociatedObject(self, &gestureKey)
        as? LongPressGestureBlock
    }

  }
}
