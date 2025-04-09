import Foundation

public protocol ConfigurableUsingClosure {}

extension ConfigurableUsingClosure {

  public func configured(usingClosure closure: (inout Self) -> Void) -> Self {
    var mutableSelf = self
    closure(&mutableSelf)
    return mutableSelf
  }
}
