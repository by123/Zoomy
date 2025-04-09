//
//  ImageZoomTapGestureRecognizer.swift
//  Artguru
//
//  Created by by on 2025/4/8.
//  Copyright © 2025 Mobiuspace. All rights reserved.
//

import Foundation

class ImageZoomTapGestureRecognizer: UITapGestureRecognizer {
  var onTouchBegan: (() -> Void)?
  var onTouchEnded: (() -> Void)?

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    onTouchBegan?()
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesEnded(touches, with: event)
    onTouchEnded?()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesCancelled(touches, with: event)
    onTouchEnded?()
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    onTouchEnded?()
  }

}
