//
//  UIStackView+Helper.swift
//  
//
//  Created by Windy on 01/09/23.
//

import UIKit

public extension UIStackView {
   
    @discardableResult
    func margin(_ margin: UIEdgeInsets) -> Self {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = margin
        return self
    }
    
    @discardableResult
    func addArrangedSubviews(_ views: [UIView]) -> Self {
        views.forEach { view in
            addArrangedSubview(view)
        }
        return self
    }
    
    @discardableResult
    func removeAllArrangedSubviews() -> Self {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        return self
    }
}
