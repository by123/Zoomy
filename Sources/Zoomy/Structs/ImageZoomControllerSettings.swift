import UIKit

public struct ImageZoomControllerSettings: ConfigurableUsingClosure {

  public init() {}

  /// When scale of imageView is below this threshold when initial pinch gesture ends, the overlay will be dismissed
  public var zoomCancelingThreshold: ImageViewScale = 1.5

  /// The minimum zoomscale at which an image will be displayed
  /// When this value is nil or greater than the initial imageScale, the initialImage scale will be used
  /// Since images are often bigger than their initial frame size, this value is typically quite small.
  public var minimumZoomScale: ImageScale? = nil

  /// The maximum zoomsScale at which an image will be displayed
  public var maximumZoomScale: ImageScale = 2

  /// Causes the behavior of the ImageZoomController to (temporarily) be disabled when needed
  public var isEnabled = true

  /// Whether or not a background view needs to be displayed behind the zoomed imageViews
  public var shouldDisplayBackground = false

  /// The animators that will be used when Zoomy.Delegate doesn't provide an animator for needed events
  public var defaultAnimators: CanProvideAnimatorForEvent = DefaultAnimators()

  /// BackgroundView's color will animate to this value when content becomes smaller than the view it's displayed in
  /// This will only have effect when shouldDisplayBackground is set to true
  public var primaryBackgroundColor = UIColor.black.withAlphaComponent(0.6)

  /// BackgroundView's color will animate to this value when content becomes bigger than or equal to any dimension of the view it's displayed in
  /// This will only have effect when shouldDisplayBackground is set to true
  public var secondaryBackgroundColor = UIColor.black

  /// The scale at which the primary backgroundColor will be fully visible, alpha is lower before that
  public var primaryBackgroundColorThreshold: ImageViewScale = 2

  /// The translation at which the background will be fully transparant, alpha is higher before that
  public var backgroundAlphaDismissalTranslationThreshold: CGFloat = 300

  /// Whether or not warnings and errors should be logged to the console
  public var shouldLogWarningsAndErrors = true

  /// The amount of point that have to be panned while scrollView is bouncing in order to dismiss the overlay
  /// Note: Settings this value alone doesn't have effect when dismissal by bounce is not enabled
  public var neededTranslationToDismissOverlayOnScrollBounce: CGFloat = 80

  /// The action that will be triggered when the imageView is tapped
  public var actionOnTapImageView: Action & CanBeTriggeredByImageViewTap =
    Action.none

  /// The action that will be triggerend when the imageView is double tapped
  public var actionOnDoubleTapImageView:
    Action & CanBeTriggeredByImageViewDoubleTap = Action.none

  /// The action that will be triggered when the overlay is tapped
  public var actionOnTapOverlay: Action & CanBeTriggeredByOverlayTap = Action
    .none

  /// The action that will be triggered when the overlay is double tapped
  public var actionOnDoubleTapOverlay:
    Action & CanBeTriggeredByOverlayDoubleTap = Action.none

  /// The action that will be triggered when the overlay is tapped
  public var actionOnTapBackgroundView:
    Action & CanBeTriggeredByBackgroundViewTap = Action.none

  /// The action that will be triggered when the backgroundView is double tapped
  public var actionOnDoubleTapBackgroundView:
    Action & CanBeTriggeredByBackgroundDoubleTap = Action.none

  /// The action that will be triggered when scrollView is bouncing while scrolling towards the top
  public var actionOnScrollBounceTop: Action & CanBeTriggeredByScrollBounceTop =
    Action.none

  /// The action that will be triggered when scrollView is bouncing while scrolling towards the left
  public var actionOnScrollBounceLeft:
    Action & CanBeTriggeredByScrollBounceLeft = Action.none

  /// The action that will be triggered when scrollView is bouncing while scrolling towards the right
  public var actionOnScrollBounceRight:
    Action & CanBeTriggeredByScrollBounceRight = Action.none

  /// The action that will be triggered when scrollView is bouncing while scrolling towards the bottom
  public var actionOnScrollBounceBottom:
    Action & CanBeTriggeredByScrollBounceBottom = Action.none

}

// MARK: Presets
extension ImageZoomControllerSettings {
  public static var defaultSettings: Settings {
    return Settings()
  }

  public static var backgroundEnabledSettings: Settings {
    return defaultSettings.with(shouldDisplayBackground: true)
  }

  public static var noZoomCancellingSettings: Settings {
    return defaultSettings.with(zoomCancelingThreshold: 1)
  }

  public static var instaZoomSettings: Settings {
    return backgroundEnabledSettings.with(zoomCancelingThreshold: .infinity)
      .with(
        defaultAnimators: DefaultAnimators().with(
          dismissalAnimator: SpringAnimator(duration: 0.6, springDamping: 1)))
  }
}

//MARK: Alterations
extension ImageZoomControllerSettings {

  public func with(zoomCancelingThreshold: ImageViewScale) -> Settings {
    var settings = self
    settings.zoomCancelingThreshold = zoomCancelingThreshold
    return settings
  }

  public func with(minimumZoomScale: ImageScale?) -> Settings {
    var settings = self
    settings.minimumZoomScale = minimumZoomScale
    return settings
  }

  public func with(maximumZoomScale: ImageScale) -> Settings {
    var settings = self
    settings.maximumZoomScale = maximumZoomScale
    return settings
  }

  public func with(isEnabled: Bool) -> Settings {
    var settings = self
    settings.isEnabled = isEnabled
    return settings
  }

  public func with(shouldDisplayBackground: Bool) -> Settings {
    var settings = self
    settings.shouldDisplayBackground = shouldDisplayBackground
    return settings
  }

  public func with(primaryBackgroundColor: UIColor) -> Settings {
    var settings = self
    settings.primaryBackgroundColor = primaryBackgroundColor
    return settings
  }

  public func with(secondaryBackgroundColor: UIColor) -> Settings {
    var settings = self
    settings.secondaryBackgroundColor = secondaryBackgroundColor
    return settings
  }

  public func with(neededTranslationToDismissOverlayOnScrollBounce: CGFloat)
    -> Settings
  {
    var settings = self
    settings.neededTranslationToDismissOverlayOnScrollBounce =
      neededTranslationToDismissOverlayOnScrollBounce
    return settings
  }

  public func with(actionOnTapOverlay: Action & CanBeTriggeredByOverlayTap)
    -> Settings
  {
    var settings = self
    settings.actionOnTapOverlay = actionOnTapOverlay
    return settings
  }

  public func with(
    actionOnDoubleTapOverlay: Action & CanBeTriggeredByOverlayDoubleTap
  ) -> Settings {
    var settings = self
    settings.actionOnDoubleTapOverlay = actionOnDoubleTapOverlay
    return settings
  }

  public func with(
    actionOnTapBackgroundView: Action & CanBeTriggeredByBackgroundViewTap
  ) -> Settings {
    var settings = self
    settings.actionOnTapBackgroundView = actionOnTapBackgroundView
    return settings
  }

  public func with(
    actionOnDoubleTapBackgroundView: Action
      & CanBeTriggeredByBackgroundDoubleTap
  ) -> Settings {
    var settings = self
    settings.actionOnDoubleTapBackgroundView = actionOnDoubleTapBackgroundView
    return settings
  }

  public func with(
    actionOnScrollBounceTop: Action & CanBeTriggeredByScrollBounceTop
  ) -> Settings {
    var settings = self
    settings.actionOnScrollBounceTop = actionOnScrollBounceTop
    return settings
  }

  public func with(
    actionOnScrollBounceLeft: Action & CanBeTriggeredByScrollBounceLeft
  ) -> Settings {
    var settings = self
    settings.actionOnScrollBounceLeft = actionOnScrollBounceLeft
    return settings
  }

  public func with(
    actionOnScrollBounceRight: Action & CanBeTriggeredByScrollBounceRight
  ) -> Settings {
    var settings = self
    settings.actionOnScrollBounceRight = actionOnScrollBounceRight
    return settings
  }

  public func with(
    actionOnScrollBounceBottom: Action & CanBeTriggeredByScrollBounceBottom
  ) -> Settings {
    var settings = self
    settings.actionOnScrollBounceBottom = actionOnScrollBounceBottom
    return settings
  }

  public func with(actionOnTapImageView: Action & CanBeTriggeredByImageViewTap)
    -> Settings
  {
    var settings = self
    settings.actionOnTapImageView = actionOnTapImageView
    return settings
  }

  public func with(
    actionOnDoubleTapImageView: Action & CanBeTriggeredByImageViewDoubleTap
  ) -> Settings {
    var settings = self
    settings.actionOnDoubleTapImageView = actionOnDoubleTapImageView
    return settings
  }

  public func with(defaultAnimators: CanProvideAnimatorForEvent) -> Settings {
    var settings = self
    settings.defaultAnimators = defaultAnimators
    return settings
  }

}
