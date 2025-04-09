import UIKit

extension UIImageView: Zoomable {

  public var view: UIView {
    return self
  }
  
  public func hidden(_ isHidden: Bool) {
    self.isHidden = isHidden
  }
}
