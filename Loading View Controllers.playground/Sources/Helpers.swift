import UIKit

extension UIView {
    public func constrainEqual(
        attribute: NSLayoutConstraint.Attribute,
        to: AnyObject,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) {
        constrainEqual(attribute: attribute, to: to, attribute, multiplier: multiplier, constant: constant)
    }
    
    public func constrainEqual(
        attribute: NSLayoutConstraint.Attribute,
        to: AnyObject,
        _ toAttribute: NSLayoutConstraint.Attribute,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .equal,
                toItem: to,
                attribute: toAttribute,
                multiplier: multiplier,
                constant: constant
            )
        ])
    }
    
    public func constrainEdges(toMarginOf view: UIView) {
        constrainEqual(attribute: .top, to: view, .topMargin)
        constrainEqual(attribute: .leading, to: view, .leadingMargin)
        constrainEqual(attribute: .trailing, to: view, .trailingMargin)
        constrainEqual(attribute: .bottom, to: view, .bottomMargin)
    }
    
    public func center(inView view: UIView) {
        centerXAnchor.constrainEqual(anchor: view.centerXAnchor)
        centerYAnchor.constrainEqual(anchor: view.centerYAnchor)
    }
}

extension NSLayoutAnchor {
    @objc public func constrainEqual(anchor: NSLayoutAnchor, constant: CGFloat = 0) {
        constraint(equalTo: anchor, constant: constant).isActive = true
    }
}


public func mainQueue(block: @escaping () -> ()) {
    DispatchQueue.main.async {
        block()
    }
}
