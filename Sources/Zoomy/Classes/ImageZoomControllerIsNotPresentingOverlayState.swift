import UIKit

class ImageZoomControllerIsNotPresentingOverlayState {

  private weak var owner: ImageZoomController?

  init(owner: ImageZoomController) {
    self.owner = owner
  }
}

// MARK: - ImageZoomControllerState
extension ImageZoomControllerIsNotPresentingOverlayState:
  ImageZoomControllerState {

  func presentOverlay() {
    guard let owner = owner,
      let imageView = owner.imageView,
      let view = owner.containerView
    else { return }

    owner.setupImage()

    guard let absoluteFrameOfImageView = owner.initialAbsoluteFrameOfImageView
    else { return }

    imageView.view.alpha = 0

    if owner.settings.shouldDisplayBackground {
      if let topMostView = owner.topmostView {
        view.insertSubview(owner.backgroundView, belowSubview: topMostView)
      } else {
        view.addSubview(owner.backgroundView)
      }

      owner.backgroundView.alpha = 0
      owner.backgroundView.pinEdgesToSuperviewEdges()
    }

    if let topMostView = owner.topmostView {
      view.insertSubview(owner.overlayImageView, belowSubview: topMostView)
    } else {
      view.addSubview(owner.overlayImageView)
    }

    owner.overlayImageView.image = owner.image
    owner.overlayImageView.frame = absoluteFrameOfImageView
    owner.overlayImageView.contentMode = imageView.contentMode

    defer {
      owner.delegate?.didBeginPresentingOverlay(for: imageView)
    }

    owner.state = IsPresentingImageViewOverlayState(owner: owner)
  }

  func zoomToFit() {
    presentOverlay()
    guard owner?.state !== self else { return }
    owner?.state.zoomToFit()
  }

  func zoomIn(with gestureRecognizer: UIGestureRecognizer?) {
    presentOverlay()
    guard owner?.state !== self else { return }
    owner?.state.zoomIn(with: gestureRecognizer)
  }

  func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {
    guard gestureRecognizer.state == .began else { return }

    presentOverlay()
    guard owner?.state !== self else { return }
    owner?.state.didPinch(with: gestureRecognizer)
  }
}
