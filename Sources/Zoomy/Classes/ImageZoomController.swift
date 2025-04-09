import UIKit

public class ImageZoomController: NSObject {
  // MARK: Public Properties

  /// Gets callbacks on important events in the ImageZoomController's lifeCycle
  public weak var delegate: Zoomy.Delegate?

  public var settings: Settings

  /// View in which zoom will take place
  weak public private(set) var containerView: UIView?

  /// View which will always be in front of the presented zoom content
  weak public private(set) var topmostView: UIView?

  /// The imageView that is to be the source of the contrast
  weak public private(set) var contrastImageView: Zoomable?

  /// The imageView that is to be the source of the zoom interactions
  weak public private(set) var imageView: Zoomable?

  /// When zoom gesture ends while currentZoomScale is below minimumZoomScale, the overlay will be dismissed
  public private(set) lazy var minimumZoomScale = neededMinimumZoomScale()

  // MARK: Properties
  private(set) var image: UIImage? {
    didSet {
      guard let image = image else { return }
      print("Changed to \(image)")
      minimumZoomScale = neededMinimumZoomScale()
      initialAbsoluteFrameOfImageView = absoluteFrame(of: imageView?.view)
    }
  }

  private(set) var contrastImage: UIImage?

  var state: ImageZoomState! {
    didSet {
      guard let state = state else { return }
      print("Changed to \(state)")
    }
  }

  var shouldAdjustScrollViewFrameAfterZooming = true

  var currentBounceOffsets: BounceOffsets?

  /// the scale is applied on the imageView where a scale of 1 results in the orinal imageView's size
  var minimumPinchScale: ImageViewScale {
    return pinchScale(from: minimumZoomScale)
  }

  /// [See GitHub Issue](https://github.com/lvnkmn/Zoomy/issues/40)
  var initialAbsoluteFrameOfImageView: CGRect? {
    didSet {
      guard
        let initialAbsoluteFrameOfImageView = initialAbsoluteFrameOfImageView
      else { return }
      print("changed to \(initialAbsoluteFrameOfImageView)")
    }
  }

  private(set) lazy var scrollableImageView =
    factory.makeScrollableImageView(for: self)
  private(set) lazy var overlayImageView =
    factory.makeOverlayImageView(for: self)
  private(set) lazy var scrollView = factory.makeScrollView(for: self)
  private(set) lazy var backgroundView = factory.makeBackgroundView(
    for: self)

  private(set) lazy var imageViewPinchGestureRecognizer =
    factory.makePinchGestureRecognizer(for: self)
  private(set) lazy var imageViewPanGestureRecognizer =
    factory.makePanGestureRecognizer(for: self)
  private(set) lazy var imageViewTapGestureRecognizer =
    factory.makeTapGestureRecognizer(for: self)
  private(set) lazy var imageViewDoubleTapGestureRecognizer =
    factory.makeDoubleTapGestureRecognizer(for: self)

  private(set) lazy var backgroundViewTapGestureRecognizer =
    factory.makeTapGestureRecognizer(for: self)
  private(set) lazy var backgroundViewDoubleTapGestureRecognizer =
    factory.makeDoubleTapGestureRecognizer(for: self)

  private(set) lazy var scrollableImageViewTapGestureRecognizer =
    factory.makeTapGestureRecognizer(for: self)
  private(set) lazy var scrollableDoubleTapGestureRecognizer =
    factory.makeDoubleTapGestureRecognizer(for: self)
  private(set) lazy var scrollableImageViewPanGestureRecognizer =
    factory.makePanGestureRecognizer(for: self)

  // MARK: Private Properties
  private let factory: Factory

  /// the scale is applied on the imageView where a scale of 1 results in the orinal imageView's size
  private var maximumPinchScale: ImageViewScale {
    return pinchScale(from: settings.maximumZoomScale)
  }

  /// Initializer
  ///
  /// - Parameters:
  ///   - container: view in which zoom will take place, has to be an ansestor of imageView
  ///   - imageView: the imageView that is to be the source of the zoom interactions
  ///   - delegate: delegate
  ///   - settings: mutable settings that will be applied on this ImageZoomController
  public convenience init(
    container containerView: UIView,
    imageView: Zoomable,
    contrastImageView: Zoomable,
    delegate: Zoomy.Delegate?,
    settings: Settings
  ) {
    self.init(
      container: containerView,
      imageView: imageView,
      contrastImageView: contrastImageView,
      topmostView: nil,
      delegate: delegate,
      settings: settings)
  }

  /// Initializer
  ///
  /// - Parameters:
  ///   - container: view in which zoom will take place, has to be an ansestor of imageView
  ///   - imageView: the imageView that is to be the source of the zoom interactions
  public convenience init(
    container containerView: UIView,
    imageView: UIImageView,
    contrastImageView: Zoomable
  ) {
    self.init(
      container: containerView,
      imageView: imageView,
      contrastImageView: contrastImageView,
      delegate: nil,
      settings: .defaultSettings)
  }

  /// Initializer
  ///
  /// - Parameters:
  ///   - container: view in which zoom will take place, has to be an ansestor of imageView
  ///   - imageView: the imageView that is to be the source of the zoom interactions
  ///   - delegate: delegate
  public convenience init(
    container containerView: UIView,
    imageView: UIImageView,
    contrastImageView: UIImageView,
    delegate: ImageZoomControllerDelegate
  ) {
    self.init(
      container: containerView,
      imageView: imageView,
      contrastImageView: contrastImageView,
      delegate: delegate,
      settings: .defaultSettings)
  }

  /// Initializer
  ///
  /// - Parameters:
  ///   - container: view in which zoom will take place, has to be an ansestor of imageView
  ///   - imageView: the imageView that is to be the source of the zoom interactions
  ///   - settings: mutable settings that will be applied on this ImageZoomController
  public convenience init(
    container containerView: UIView,
    imageView: UIImageView,
    contrastImageView: UIImageView,
    settings: ImageZoomControllerSettings
  ) {
    self.init(
      container: containerView,
      imageView: imageView,
      contrastImageView: contrastImageView,
      delegate: nil,
      settings: settings)
  }

  init(
    container containerView: UIView,
    imageView: Zoomable,
    contrastImageView: Zoomable,
    topmostView: UIView?,
    delegate: Zoomy.Delegate?,
    settings: Settings,
    factory: Factory = Factory()
  ) {
    self.containerView = containerView
    self.topmostView = topmostView
    self.imageView = imageView
    self.contrastImageView = contrastImageView
    self.delegate = delegate
    self.settings = settings
    self.factory = factory

    print("对比图\(self.contrastImageView?.image)")
    super.init()

    state = IsNotPresentingOverlayState(owner: self)
    configureImageView()
    print("done\n")
  }

  // MARK: Deinitalizer
  deinit {
    imageView?.view.removeGestureRecognizer(imageViewPinchGestureRecognizer)
    imageView?.view.removeGestureRecognizer(imageViewPanGestureRecognizer)
  }
}

// MARK: Public methods
extension ImageZoomController {

  /// Dismiss all currently presented overlays
  public func dismissOverlay() {
    state.dismissOverlay()
  }

  /// Reset imageView and viewHierarchy to the state prior to initializing the zoomControlelr
  public func reset() {
    imageView?.view.removeGestureRecognizer(imageViewPinchGestureRecognizer)
    imageView?.view.removeGestureRecognizer(imageViewPanGestureRecognizer)
    imageView?.view.removeGestureRecognizer(imageViewTapGestureRecognizer)
    imageView?.view.removeGestureRecognizer(imageViewDoubleTapGestureRecognizer)
    imageView?.view.alpha = 1

    resetOverlayImageView()
    resetScrollView()

    if settings.shouldDisplayBackground {
      backgroundView.removeFromSuperview()
    }

    state = IsNotPresentingOverlayState(owner: self)
    print("Did reset\n\n\n\n\n\n\n\n")
  }
}

// MARK: Events
extension ImageZoomController {

  @objc func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {
    guard settings.isEnabled else { return }

    state.didPinch(with: gestureRecognizer)
  }

  @objc func didPan(with gestureRecognizer: UIPanGestureRecognizer) {
    guard settings.isEnabled else { return }

    state.didPan(with: gestureRecognizer)
  }

  @objc func didDoubleTap(with gestureRecognizer: UITapGestureRecognizer) {
    guard settings.isEnabled,
      let action = gestureRecognizerActions[gestureRecognizer]
    else { return }
    perform(action: action, triggeredBy: gestureRecognizer)
  }

  @objc func didTap(with gestureRecognizer: UITapGestureRecognizer) {
    print("点击 taptaptap")
  }
}

// MARK: CanPerformAction
extension ImageZoomController: CanPerformAction {

  func perform(
    action: ImageZoomControllerAction,
    triggeredBy gestureRecognizer: UIGestureRecognizer? = nil
  ) {
    print(action)
    guard !(action is Action.None) else { return }

    if action is Action.DismissOverlay {
      state.dismissOverlay()
    } else if action is Action.ZoomToFit {
      state.zoomToFit()
    } else if action is Action.ZoomIn {
      state.zoomIn(with: gestureRecognizer)
    }
  }
}

// MARK: Setup
extension ImageZoomController {

  func configureImageView() {
    imageView?.view.addGestureRecognizer(imageViewPinchGestureRecognizer)
    imageView?.view.addGestureRecognizer(imageViewPanGestureRecognizer)
    imageView?.view.addGestureRecognizer(imageViewTapGestureRecognizer)
    imageView?.view.addGestureRecognizer(imageViewDoubleTapGestureRecognizer)
    imageView?.view.isUserInteractionEnabled = true
  }

  func setupImage() {
    validateImageView()
    self.image = imageView?.image
    self.contrastImage = contrastImageView?.image
  }


  private func validateImageView() {
    guard let imageView = imageView else { return }

    if imageView.image == nil,
      settings.shouldLogWarningsAndErrors
    {
      print(
        "Provided imageView did not have an image at this time, this is likely to have effect on the zoom behavior."
      )
    }
  }
}

// MARK: Calculations
extension ImageZoomController {

  func adjustedScrollViewFrame() -> CGRect {
    guard let containerView = containerView,
      let initialAbsoluteFrameOfImageView = initialAbsoluteFrameOfImageView
    else { return CGRect.zero }

    let initialHorizontalLeadingSpaceToContainer =
      initialAbsoluteFrameOfImageView.origin.x
    let initialHorizontalSpaceToContainer =
      containerView.frame.size.width - initialAbsoluteFrameOfImageView.width
    let leadingHorizontalSpaceRatio =
      initialHorizontalSpaceToContainer != 0
      ? initialHorizontalLeadingSpaceToContainer
        / initialHorizontalSpaceToContainer : 0

    let widthGrowth =
      (scrollView.contentSize.width - initialAbsoluteFrameOfImageView.width)

    let originX = max(
      initialAbsoluteFrameOfImageView.origin.x - widthGrowth
        * leadingHorizontalSpaceRatio, 0)
    let originY = max(
      initialAbsoluteFrameOfImageView.origin.y
        - (scrollView.contentSize.height
          - initialAbsoluteFrameOfImageView.height) / 2,
      0)
    let width = min(scrollView.contentSize.width, containerView.frame.width)
    let height = min(scrollView.contentSize.height, containerView.frame.height)

    return CGRect(
      x: originX,
      y: originY,
      width: width,
      height: height)
  }

  /// Shows how much the provided content offset will be corrected if applied to the scrollView
  ///
  /// - Parameter contentOffset: the contentOffset
  /// - Returns: the correction
  func contentOffsetCorrection(on contentOffset: CGPoint) -> CGPoint {
    let offsetX: CGFloat
    if contentOffset.x < 0 {
      offsetX = contentOffset.x
    } else if contentOffset.x
      - (scrollView.contentSize.width - scrollView.frame.size.width) > 0 {
      offsetX =
        contentOffset.x
        - (scrollView.contentSize.width - scrollView.frame.size.width)
    } else {
      offsetX = 0
    }

    let offsetY: CGFloat
    if contentOffset.y + adjustedContentInset(from: scrollView).top < 0 {
      offsetY = contentOffset.y + adjustedContentInset(from: scrollView).top
    } else if contentOffset.y
      - (scrollView.contentSize.height - scrollView.frame.size.height
        + adjustedContentInset(from: scrollView).bottom) > 0
    {
      offsetY =
        contentOffset.y
        - (scrollView.contentSize.height - scrollView.frame.size.height
          + adjustedContentInset(from: scrollView).bottom)
    } else {
      offsetY = 0
    }

    return CGPoint(x: offsetX, y: offsetY)
  }

  /// Returns what the provided contentOffset will turn into when applied on the scrollView
  ///
  /// - Parameter contentOffset: contentOffset
  /// - Returns: corrected contentOffset
  func corrected(contentOffset: CGPoint) -> CGPoint {
    let correction = contentOffsetCorrection(on: contentOffset)
    return CGPoint(
      x: contentOffset.x - correction.x,
      y: contentOffset.y - correction.y)
  }

  func zoomScale(from imageView: Zoomable?) -> ImageScale {
    guard let imageView = imageView,
      let image = image
    else { return 1 }
    return imageView.view.frame.size.width / image.size.width
  }

  func zoomScale(from pinchScale: ImageViewScale) -> ImageScale {
    return pinchScale * minimumZoomScale
  }

  func pinchScale(from zoomScale: ImageScale) -> ImageViewScale {
    return zoomScale / minimumZoomScale
  }

  /// Adds the bounce like behavior to the provided pinchScale
  ///
  /// - Parameter pinchScale: pinchScale
  /// - Returns: pinchScale
  func adjust(pinchScale: ImageViewScale) -> ImageViewScale {
    guard pinchScale < minimumPinchScale || pinchScale > maximumPinchScale
    else { return pinchScale }

    let bounceScale = sqrt(3)
    let scaleX: ImageViewScale
    let scaleK: ImageViewScale
    if pinchScale < minimumPinchScale {
      scaleX = pinchScale / minimumPinchScale
      scaleK = ImageViewScale(1 / bounceScale)
      return minimumPinchScale
        * ((2 * scaleK - 1) * pow(scaleX, 3) + (2 - 3 * scaleK) * pow(scaleX, 2)
          + scaleK)
    } else {  // pinchScale > maximumPinchScale
      scaleX = pinchScale / maximumPinchScale
      scaleK = ImageViewScale(bounceScale)
      return maximumPinchScale
        * ((2 * scaleK - 2) / (1 + exp(4 / scaleK * (1 - scaleX))) - scaleK + 2)
    }
  }

  func absoluteFrame(of subjectView: UIView?) -> CGRect {
    guard let subjectView = subjectView,
      let view = containerView
    else { return CGRect.zero }

    return view.convert(subjectView.frame, from: subjectView.superview)
  }

  func maximumImageSize() -> CGSize {
    guard let imageView = imageView else { return CGSize.zero }
    let view = UIView()
    view.frame = imageView.view.frame
    view.transform = view.transform.scaledBy(
      x: maximumPinchScale, y: maximumPinchScale)
    return view.frame.size
  }

  func adjustedContentInset(from scrollView: UIScrollView) -> UIEdgeInsets {
    if #available(iOS 11.0, *) {
      return scrollView.adjustedContentInset
    } else {
      return scrollView.contentInset
    }
  }

  func bounceOffsets(from scrollView: UIScrollView) -> BounceOffsets {
    return BounceOffsets(
      top: max(
        scrollView.contentOffset.y
          - (scrollView.contentSize.height - scrollView.frame.size.height)
          - adjustedContentInset(from: scrollView).bottom, 0),
      left: max(
        scrollView.contentOffset.x
          - (scrollView.contentSize.width - scrollView.frame.size.width)
          - adjustedContentInset(from: scrollView).left, 0),
      bottom: abs(
        min(
          scrollView.contentOffset.y
            + adjustedContentInset(from: scrollView).top, 0)),
      right: abs(
        min(
          scrollView.contentOffset.x
            + adjustedContentInset(from: scrollView).right, 0)))
  }

  func imageDoesntFitScreen() -> Bool {
    guard let view = containerView else { return false }
    return scrollView.contentSize.width > view.frame.size.width
  }

  func size(of image: UIImage, at zoomScale: ImageScale) -> CGSize {
    return CGSize(
      width: image.size.width * zoomScale,
      height: image.size.height * zoomScale)
  }

  func neededMinimumZoomScale() -> ImageScale {
    let initialZoomScale = zoomScale(from: imageView)
    if let minimumZoomScale = settings.minimumZoomScale {
      if minimumZoomScale > initialZoomScale {
        print(
          "MinimumZoomScale (\(minimumZoomScale) specified in settings is greater than initial zoom scale (\(initialZoomScale)) and will be ignored"
        )
        return initialZoomScale
      } else {
        return minimumZoomScale
      }
    } else {
      return initialZoomScale
    }
  }
}

// MARK: Other
extension ImageZoomController {

  private var gestureRecognizerActions: [UIGestureRecognizer: Action] {
    return [
      imageViewTapGestureRecognizer: settings.actionOnTapImageView,
      imageViewDoubleTapGestureRecognizer: settings.actionOnDoubleTapImageView,
      backgroundViewTapGestureRecognizer: settings.actionOnTapBackgroundView,
      backgroundViewDoubleTapGestureRecognizer: settings
        .actionOnDoubleTapBackgroundView,
      scrollableImageViewTapGestureRecognizer: settings.actionOnTapOverlay,
      scrollableDoubleTapGestureRecognizer: settings
        .actionOnDoubleTapOverlay,
    ]
  }

  private func adjustFrame(of scrollView: UIScrollView) {
    let oldScrollViewFrame = scrollView.frame
    scrollView.frame = adjustedScrollViewFrame()
    let frameDifference = scrollView.frame.difference(with: oldScrollViewFrame)
    scrollView.contentOffset = CGPoint(
      x: scrollView.contentOffset.x + frameDifference.origin.x,
      y: scrollView.contentOffset.y + frameDifference.origin.y)
  }

  func resetScrollView() {
    scrollableImageView.removeFromSuperview()
    scrollableImageView = factory.makeScrollableImageView(for: self)
    scrollView.removeFromSuperview()
    scrollView = factory.makeScrollView(for: self)
    currentBounceOffsets = nil
  }

  func resetOverlayImageView() {
    overlayImageView.removeFromSuperview()
    overlayImageView = factory.makeOverlayImageView(for: self)
  }
}

// MARK: CanProvideAnimatorForEvent
extension ImageZoomController: CanProvideAnimatorForEvent {

  public func animator(for event: AnimationEvent) -> CanAnimate {
    return delegate?.animator(for: event)
      ?? settings.defaultAnimators.animator(for: event)
  }
}

// MARK: UIScrollViewDelegate
extension ImageZoomController: UIScrollViewDelegate {

  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return scrollableImageView
  }

  public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    if shouldAdjustScrollViewFrameAfterZooming {
      adjustFrame(of: scrollView)
    }

    state.scrollViewDidZoom(scrollView)
  }

  public func scrollViewWillBeginZooming(
    _ scrollView: UIScrollView, with view: UIView?
  ) {
    state.scrollViewWillBeginZooming(scrollView, with: view)
  }

  public func scrollViewDidEndZooming(
    _ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat
  ) {
    state.scrollViewDidEndZooming(scrollView, with: view, atScale: scale)
  }

  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    state.scrollViewWillBeginDragging(scrollView)
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    currentBounceOffsets = bounceOffsets(from: scrollView)
  }
}

// MARK: UIGestureRecognizerDelegate
extension ImageZoomController: UIGestureRecognizerDelegate {
  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
      UIGestureRecognizer
  ) -> Bool {
    if gestureRecognizer == imageViewPinchGestureRecognizer,
      gestureRecognizer.numberOfTouches > 1,
      otherGestureRecognizer is UIPanGestureRecognizer
        && otherGestureRecognizer != imageViewPanGestureRecognizer
    {
      return false
    }
    return true
  }

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    if gestureRecognizer == imageViewPinchGestureRecognizer,
      gestureRecognizer.numberOfTouches > 1,
      otherGestureRecognizer is UIPanGestureRecognizer
        && otherGestureRecognizer != imageViewPanGestureRecognizer
    {
      return true
    }
    return false
  }

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch
  ) -> Bool {
    guard let action = gestureRecognizerActions[gestureRecognizer] else {
      return true
    }

    return !(action is Action.None)
  }
}
