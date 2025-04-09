import UIKit

public protocol Zoomable: AnyObject {
  var image: UIImage? { get set }
  var view: UIView { get }
  var contentMode: UIView.ContentMode { get }

}
