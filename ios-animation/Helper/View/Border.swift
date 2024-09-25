//
//  Border.swift
//  
//
//  Created by Windy on 15/07/22.
//

import UIKit

/// Configuration to set inner border of the view.
///
/// Set value of the color and width of the border.
///
/// Use ``BorderModifiable/border(_:)`` to apply this border.
/// If you use UIView, you can call this to apply the border.
public struct Border {
    let color: UIColor?
    let width: CGFloat
    
    public init(color: UIColor?, width: CGFloat) {
        self.color = color
        self.width = width
    }
}

extension Border {
    public static var none: Border {
        Border(color: nil, width: 0)
    }
}

public protocol BorderModifiable {
    associatedtype BorderBase
    
    /// Apply the view's inner border.
    /// - Parameter border: The border to be applied.
    /// - Returns: View with border.
    ///
    /// Inner border will be drawed inside the view's frame area.
    @discardableResult
    func border(_ border: Border) -> BorderBase
    
}

extension UIView: BorderModifiable {
    public typealias BorderBase = UIView
    
    @discardableResult
    public func border(_ border: Border) -> Self {
        layer.borderWidth = border.width
        layer.borderColor = border.color?.resolvedColor(with: traitCollection).cgColor
        return self
    }
    
}
