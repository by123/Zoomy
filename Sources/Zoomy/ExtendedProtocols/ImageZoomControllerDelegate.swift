import UIKit

public protocol ImageZoomControllerDelegate: AnyObject {

  func didBeginPresentingOverlay(for imageView: Zoomable)
  func didEndPresentingOverlay(for imageView: Zoomable)
  func willDismissOverlay()
  func contentStateDidChange(
    from fromState: ImageZoomControllerContentState,
    to toState: ImageZoomControllerContentState)
  func animator(for event: AnimationEvent) -> CanAnimate?
}

extension ImageZoomControllerDelegate {

  public func didBeginPresentingOverlay(for imageView: Zoomable) {}
  public func didEndPresentingOverlay(for imageView: Zoomable) {}
  public func willDismissOverlay() {}
  public func contentStateDidChange(
    from fromState: ImageZoomControllerContentState,
    to toState: ImageZoomControllerContentState
  ) {}
  public func animator(for event: AnimationEvent) -> CanAnimate? {
    return nil
  }
}
