public enum AnimationEvent {
  case overlayDismissal
  case positionCorrection
  case backgroundColorChange
  case zoom
}

extension AnimationEvent {

  public static var all: [AnimationEvent] {
    return [.overlayDismissal, .positionCorrection, .backgroundColorChange]
  }
}
