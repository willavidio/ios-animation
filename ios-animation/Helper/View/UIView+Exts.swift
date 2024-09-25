//
//  View+DSL.swift
//  
//
//  Created by Windy on 27/07/22.
//

import UIKit

public extension UIView {
    
    @discardableResult
    func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }
    
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    @discardableResult
    func addGesture(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        self.addGestureRecognizer(gestureRecognizer)
        return self
    }
    
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }
    
    @discardableResult
    func insetsLayoutMarginsFromSafeArea(_ value: Bool) -> Self {
        insetsLayoutMarginsFromSafeArea = value
        return self
    }
    
    @discardableResult
    func translatesAutoresizingMaskIntoConstraints(_ value: Bool) -> Self {
        translatesAutoresizingMaskIntoConstraints = value
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width {
            if let widthConstraint {
                widthConstraint.constant = width
            } else {
                widthConstraint = widthAnchor.constraint(equalToConstant: width)
                widthConstraint?.isActive = true
            }
        }
        
        if let height {
            if let heightConstraint {
                heightConstraint.constant = height
            } else {
                heightConstraint = heightAnchor.constraint(equalToConstant: height)
                heightConstraint?.isActive = true
            }
        }
        
        return self
    }
    
    @discardableResult
    func accessibilityIdentifier(_ identifier: String?) -> Self {
        accessibilityIdentifier = identifier
        return self
    }
    
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult
    func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
}

extension UIView {
    
      enum ConstraintType {
          case fill
          case center
          case safeArea
          case bottomCenter
      }
      
      func addSubview(_ view: UIView, constraints type: ConstraintType) {
          addSubview(view)
          handleAutoLayout(type: type, for: view)
      }
      
      private func handleAutoLayout(type: ConstraintType, for view: UIView) {
          view.translatesAutoresizingMaskIntoConstraints = false
          
          switch type {
          case .fill:
              view.fillToSuperview()
          case .center:
              NSLayoutConstraint.activate([
                  view.centerXAnchor.constraint(equalTo: centerXAnchor),
                  view.centerYAnchor.constraint(equalTo: centerYAnchor)
              ])
          case .safeArea:
              NSLayoutConstraint.activate([
                  view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                  view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                  view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                  view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
              ])
          case .bottomCenter:
              NSLayoutConstraint.activate([
                  view.centerXAnchor.constraint(equalTo: centerXAnchor),
                  view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
              ])
          }
      }
      
      func fillToSuperview(margin: UIEdgeInsets = .zero) {
          guard let superview = superview else { return }
          translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              topAnchor.constraint(
                  equalTo: superview.topAnchor,
                  constant: margin.top),
              bottomAnchor.constraint(
                  equalTo: superview.bottomAnchor,
                  constant: -margin.bottom),
              leadingAnchor.constraint(
                  equalTo: superview.leadingAnchor,
                  constant: margin.left),
              trailingAnchor.constraint(
                  equalTo: superview.trailingAnchor,
                  constant: -margin.right),
          ])
      }

}

private var widthConstraintKey = 0
private var heightConstraintKey = 0

private extension UIView {
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            objc_getAssociatedObject(
                self,
                &widthConstraintKey
            ) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(
                self,
                &widthConstraintKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN
            )
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            objc_getAssociatedObject(
                self,
                &heightConstraintKey
            ) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(
                self,
                &heightConstraintKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN
            )
        }
    }
    
}
