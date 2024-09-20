//
//  VStackView.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

@resultBuilder
public enum ViewBuilder {
    
    public static func buildBlock() -> [UIView] {
        []
    }
    
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }
    
    public static func buildBlock(_ components: [UIView]...) -> [UIView] {
        components.flatMap { $0 }
    }
}

public final class VStackView: UIStackView {
    
    public init(
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment? = nil,
        distribution: UIStackView.Distribution? = nil,
        @ViewBuilder arrangedSubviews: () -> [UIView]
    ) {
        super.init(frame: .zero)
        axis = .vertical
        self.spacing = spacing
        
        arrangedSubviews().forEach(addArrangedSubview)
        
        if let alignment {
            self.alignment = alignment
        }
        
        if let distribution {
            self.distribution = distribution
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension UIStackView {
    
    @discardableResult
    func margin(_ margin: UIEdgeInsets) -> Self {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = margin
        return self
    }
}
