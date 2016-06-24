import UIKit

extension UIView {
    public func constrainEqual(attribute: NSLayoutAttribute, to: AnyObject, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        constrainEqual(attribute, to: to, attribute, multiplier: multiplier, constant: constant)
    }
    
    public func constrainEqual(attribute: NSLayoutAttribute, to: AnyObject, _ toAttribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: to, attribute: toAttribute, multiplier: multiplier, constant: constant)
            ]
        )
    }
    
    public func constrainEdges(toMarginOf view: UIView) {
        constrainEqual(.Top, to: view, .TopMargin)
        constrainEqual(.Leading, to: view, .LeadingMargin)
        constrainEqual(.Trailing, to: view, .TrailingMargin)
        constrainEqual(.Bottom, to: view, .BottomMargin)
    }
    
    public func center(inView view: UIView) {
        centerXAnchor.constrainEqual(view.centerXAnchor)
        centerYAnchor.constrainEqual(view.centerYAnchor)
    }
}

extension NSLayoutAnchor {
    public func constrainEqual(anchor: NSLayoutAnchor, constant: CGFloat = 0) {
        let constraint = constraintEqualToAnchor(anchor, constant: constant)
        constraint.active = true
    }
}


public func mainQueue(block: () -> ()) {
    dispatch_async(dispatch_get_main_queue(), block)
}
