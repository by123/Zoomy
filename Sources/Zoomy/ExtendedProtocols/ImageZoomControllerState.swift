import UIKit

protocol ImageZoomControllerState: AnyObject {
  func presentOverlay()
  func dismissOverlay()
  func zoomToFit()
  func zoomIn(with gestureRecognizer: UIGestureRecognizer?)
  func didPan(with gestureRecognizer: UIPanGestureRecognizer)
  func didPinch(with gestureRecognizer: UIPinchGestureRecognizer)
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
  func scrollViewWillBeginZooming(
    _ scrollView: UIScrollView, with view: UIView?)
  func scrollViewDidEndZooming(
    _ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
  func scrollViewDidZoom(_ scrollView: UIScrollView)
}

extension ImageZoomControllerState {

  func presentOverlay() {}
  func dismissOverlay() {}
  func zoomToFit() {}
  func zoomIn(with gestureRecognizer: UIGestureRecognizer?) {}
  func didPan(with gestureRecognizer: UIPanGestureRecognizer) {}
  func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {}
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
  func scrollViewWillBeginZooming(
    _ scrollView: UIScrollView, with view: UIView?
  ) {}
  func scrollViewDidEndZooming(
    _ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat
  ) {}
  func scrollViewDidZoom(_ scrollView: UIScrollView) {}
}
