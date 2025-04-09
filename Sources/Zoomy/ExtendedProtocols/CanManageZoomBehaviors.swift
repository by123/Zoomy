import UIKit

public protocol CanManageZoomBehaviors {

  /// Will make the provided imageView zoomable
  ///
  /// - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - containerView: The containerView in which the imageView will be zoomed
  ///   - topMostView: If specified, all views that show zooming behavior will be placed underneath this view
  ///   - delegate: The delegate that will be notified on zoom related events
  ///   - settings: The settings the will be used for the zoomBehavior
  func addZoombehavior(
    for imageView: Zoomable,
    in containerView: UIView,
    contrastImageView: Zoomable,
    below topmostView: UIView?,
    delegate: Zoomy.Delegate?,
    settings: Zoomy.Settings)

  /// Will make the provided imageView no longer zoomable, it's state will be restored the the state prior to adding a zoomBehehavior for it
  ///
  /// - Parameter imageView: The imageView that should no longer be zoomable
  func removeZoomBehavior(for imageView: Zoomable)
}

extension CanManageZoomBehaviors {

  /// Will make the provided imageView zoomable with default settings and without a delegate
  ///
  /// - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - containerView: The containerView in which the imageView will be zoomed
  public func addZoombehavior(
    for imageView: Zoomable,
    in containerView: UIView,
    contrastImageView: Zoomable)
  {
    addZoombehavior(
      for: imageView,
      in: containerView,
      contrastImageView: contrastImageView,
      below: nil,
      delegate: nil,
      settings: .defaultSettings)
  }

  /// Will make the provided imageView zoomable without a delegate
  ///
  /// - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - containerView: The containerView in which the imageView will be zoomed
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    in containerView: UIView,
    contrastImageView: Zoomable,
    settings: Zoomy.Settings
  ) {
    addZoombehavior(
      for: imageView,
      in: containerView,
      contrastImageView: contrastImageView,
      below: nil,
      delegate: nil,
      settings: settings)
  }

  /// Will make the provided imageView zoomable with default settings
  ///
  /// - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - containerView: The containerView in which the imageView will be zoomed
  ///   - delegate: The delegate that will be notified on zoom related events
  public func addZoombehavior(
    for imageView: Zoomable,
    in containerView: UIView,
    contrastImageView: Zoomable,
    delegate: Zoomy.Delegate?
  ) {
    addZoombehavior(
      for: imageView,
      in: containerView,
      contrastImageView: contrastImageView,
      below: nil,
      delegate: delegate,
      settings: .defaultSettings)
  }
}

//MARK: Where HasImageZoomControllers
extension CanManageZoomBehaviors where Self: HasImageZoomControllers {

  public func addZoombehavior(
    for imageView: Zoomable,
    in containerView: UIView,
    contrastImageView: Zoomable,
    below topmostView: UIView?,
    delegate: Zoomy.Delegate?,
    settings: Zoomy.Settings
  ) {
    if let previousController = imageZoomControllers[imageView.view] {
      previousController.reset()
    }

    imageZoomControllers[imageView.view] = ImageZoomController(
      container: containerView,
      imageView: imageView,
      contrastImageView: contrastImageView,
      topmostView: topmostView,
      delegate: delegate,
      settings: settings)
  }

  public func removeZoomBehavior(for imageView: Zoomable) {
    let imageZoomController = imageZoomControllers[imageView.view]
    imageZoomController?.reset()
    imageZoomControllers.removeValue(forKey: imageView.view)
  }
}

//MARK: Where Zoomy.Delegate
extension CanManageZoomBehaviors where Self: Zoomy.Delegate {

  /// Will make the provided imageView zoomable with default settings and where the delegate is self
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    in containerView: UIView,
    contrastImageView: Zoomable
  ) {
    addZoombehavior(
      for: imageView,
      in: containerView,
      contrastImageView: contrastImageView,
      below: nil, delegate: self,
      settings: .defaultSettings)
  }

  /// Will make the provided imageView where the delegate is self
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    in containerView: UIView,
    contrastImageView: Zoomable,
    settings: Zoomy.Settings
  ) {
    addZoombehavior(
      for: imageView,
      in: containerView,
      contrastImageView: contrastImageView,
      below: nil,
      delegate: self,
      settings: settings)
  }
}

//MARK: Where UIViewController
extension CanManageZoomBehaviors where Self: UIViewController {

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - topMostView: If specified, all views that show zooming behavior will be placed underneath this view
  ///   - delegate: The delegate that will be notified on zoom related events
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    below topmostView: UIView?,
    delegate: Zoomy.Delegate?,
    settings: Zoomy.Settings
  ) {
    addZoombehavior(
      for: imageView,
      in: view,
      contrastImageView: contrastImageView,
      below: topmostView,
      delegate: delegate,
      settings: settings
    )
  }

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - topMostView: All views that show zooming behavior will be placed underneath this view
  ///   - delegate: The delegate that will be notified on zoom related events
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    below topmostView: UIView,
    delegate: Zoomy.Delegate?
  ) {
    addZoombehavior(
      for: imageView,
      in: view,
      contrastImageView: contrastImageView,
      below: topmostView, delegate: delegate,
      settings: .defaultSettings)
  }

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - topMostView: All views that show zooming behavior will be placed underneath this view
  ///   - delegate: The delegate that will be notified on zoom related events
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    below topMostView: UIView,
    delegate: Zoomy.Delegate?,
    settings: Zoomy.Settings
  ) {
    addZoombehavior(
      for: imageView,
      in: view,
      contrastImageView: contrastImageView,
      below: topMostView,
      delegate: delegate,
      settings: settings)
  }

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - delegate: The delegate that will be notified on zoom related events
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    delegate: Zoomy.Delegate?,
    settings: Zoomy.Settings
  ) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      below: nil,
      delegate: delegate,
      settings: settings)
  }

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - topMostView: All views that show zooming behavior will be placed underneath this view
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    below topmostView: UIView,
    settings: Zoomy.Settings
  ) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      below: topmostView,
      delegate: nil,
      settings: settings)
  }

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  /// - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    settings: Zoomy.Settings
  ) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      delegate: nil,
      settings: settings
    )
  }

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    delegate: Zoomy.Delegate?
  ) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      delegate: delegate,
      settings: .defaultSettings
    )
  }

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    below topmostView: UIView
  ) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      below: topmostView,
      delegate: nil
    )
  }

  /// Will make the provided imageView zoomable inside the viewControllers view
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable
  ) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      delegate: nil
    )
  }
}

//MARK: Where UIViewController, Zoomy.Delegate
extension CanManageZoomBehaviors
where Self: UIViewController, Self: Zoomy.Delegate {

  /// Will make the provided imageView zoomable inside the viewControllers view and where delegate is self
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - topMostView: If specified, all views that show zooming behavior will be placed underneath this view
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    below topmostView: UIView,
    settings: Zoomy.Settings
  ) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      below: topmostView,
      delegate: self,
      settings: settings
    )
  }

  /// Will make the provided imageView zoomable inside the viewControllers view and where delegate is self
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - topMostView: If specified, all views that show zooming behavior will be placed underneath this view
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    below topmostView: UIView
  ) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      below: topmostView,
      delegate: self)
  }

  /// Will make the provided imageView zoomable inside the viewControllers view and where delegate is self
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  ///   - settings: The settings the will be used for the zoomBehavior
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable,
    settings: Zoomy.Settings)
  {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      delegate: self,
      settings: settings
    )
  }

  /// Will make the provided imageView zoomable inside the viewControllers view with default settings and where delegate is self
  ///
  ///   - Parameters:
  ///   - imageView: The imageView that will be zoomable
  public func addZoombehavior(
    for imageView: Zoomable,
    contrastImageView: Zoomable) {
    addZoombehavior(
      for: imageView,
      contrastImageView: contrastImageView,
      delegate: self
    )
  }
}
