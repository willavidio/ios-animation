//
//  Shadow.swift
//  
//
//  Created by Windy on 15/07/22.
//

import UIKit
import Combine

/// Configuration to set shadow of the view.
///
/// Set value of the color, opacity, offset and radius of the shadow.
///
/// Use ``ShadowModifiable/shadow(_:)`` to apply this shadow.
/// If you use UIView, you can call this to apply the shadow.
public struct Shadow {
    let color: UIColor?
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
    
    public init(
        color: UIColor?,
        opacity: Float,
        offset: CGSize,
        radius: CGFloat
    ) {
        self.color = color
        self.opacity = opacity
        self.offset = offset
        self.radius = radius
    }
}

extension Shadow {
    public static var none: Shadow {
        Shadow(color: nil, opacity: 0, offset: .zero, radius: 0)
    }
    
    public static var base: Shadow {
        Shadow(color: UIColor(named: "grey80"), opacity: 0.2,
               offset: CGSize(width: 0, height: 2), radius: 8)
    }
}

public protocol ShadowModifiable {
    associatedtype ShadowBase
    
    /// Apply the view's shadow.
    /// - Parameter shadow:The  shadow to be applied
    /// - Returns: View with shadow.
    ///
    /// The shadow will be rendered automatically whenever the view's bounds is changed.
    @discardableResult
    func shadow(_ shadow: Shadow) -> ShadowBase
}

extension UIView: ShadowModifiable {
    
    public typealias ShadowBase = UIView
    
    @discardableResult
    public func shadow(_ shadow: Shadow) -> UIView {
        apply(shadow: shadow)
        layoutIfNeeded()
        
        boundsCancellable = publisher(for: \.bounds)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateShadowPath() })
        
        return self
    }
    
    private func apply(shadow: Shadow) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = shadow.color?.cgColor
        layer.shadowOpacity = shadow.opacity
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = shadow.radius
        layer.shouldRasterize = false
        updateShadowPath()
    }
    
    private func updateShadowPath() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: layer.cornerRadius).cgPath
    }
}

private var pointer: UInt8 = 0

private extension UIView {
    var boundsCancellable: AnyCancellable? {
        get {
            return objc_getAssociatedObject(self, &pointer) as? AnyCancellable
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pointer, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
