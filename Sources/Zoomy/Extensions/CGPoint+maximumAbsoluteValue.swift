import UIKit

extension CGPoint {
  var maxAbsoluteValue: CGFloat {
    return max(abs(x), abs(y))
  }
}
