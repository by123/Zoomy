import UIKit

extension UIView {

    func pinEdgesToSuperviewEdges() {
        guard let superview = superview else { return }

        translatesAutoresizingMaskIntoConstraints = false

        let edges: [NSLayoutConstraint.Attribute] = [
            .top, .right, .bottom, .left,
        ]

        for edge in edges {
            NSLayoutConstraint(
                item: self,
                attribute: edge,
                relatedBy: .equal,
                toItem: superview,
                attribute: edge,
                multiplier: 1,
                constant: 0
            ).isActive = true
        }
    }
}

private var zoomy_tapBlockKey: Void?

extension UIView {

    private var longPressBlock: LongPressGestureBlock? {
        set {
            objc_setAssociatedObject(
                self, &zoomy_tapBlockKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, &zoomy_tapBlockKey)
                as? LongPressGestureBlock
        }

    }

    typealias LongPressGestureBlock = (
        _ sender: UIView, _ gesture: UILongPressGestureRecognizer
    ) -> Void
    func addLongPressActionWithBlock(
        shouldAnimation: Bool = false,
        tapBlock: @escaping LongPressGestureBlock
    ) {
        self.longPressBlock = tapBlock
        isUserInteractionEnabled = true
        let tapGesture = UILongPressGestureRecognizer.init(
            target: self,
            action: #selector(onLongPressWithoutAnimationDelegate(sender:)))
        tapGesture.minimumPressDuration = 0.1
        addGestureRecognizer(tapGesture)
    }

    @objc private func onLongPressWithoutAnimationDelegate(
        sender: UILongPressGestureRecognizer
    ) {
        if let notNilTabBlock = self.longPressBlock {
            if sender.state == .began {
                notNilTabBlock(self, sender)
            } else if sender.state == .ended {
                notNilTabBlock(self, sender)
            }
        }
    }
}
