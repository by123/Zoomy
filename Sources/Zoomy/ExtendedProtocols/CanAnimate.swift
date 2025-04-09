public protocol CanAnimate {
  func animate(_ animations: @escaping () -> Void, completion: (() -> Void)?)
}

extension CanAnimate {

  public func animate(_ animations: @escaping () -> Void) {
    animate(animations, completion: nil)
  }
}
