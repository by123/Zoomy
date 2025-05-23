import UIKit

public protocol HasImageZoomControllers: AnyObject {

  var imageZoomControllers: [UIView: ImageZoomController] { get set }
}

extension HasImageZoomControllers where Self: NSObject {

  public var imageZoomControllers: [UIView: ImageZoomController] {
    get {
      if let existingZoomControllers = objc_getAssociatedObject(
        self, &type(of: self).AsociatedKeys.imageZoomControllers)
        as? [UIView: ImageZoomController]
      {
        return existingZoomControllers
      } else {
        let newZoomControllers = [UIView: ImageZoomController]()
        objc_setAssociatedObject(
          self, &type(of: self).AsociatedKeys.imageZoomControllers,
          newZoomControllers, .OBJC_ASSOCIATION_RETAIN)
        return newZoomControllers
      }
    }
    set {
      objc_setAssociatedObject(
        self, &type(of: self).AsociatedKeys.imageZoomControllers, newValue,
        .OBJC_ASSOCIATION_RETAIN)
    }
  }
}
