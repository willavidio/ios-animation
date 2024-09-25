//
//  UILabel.swift
//
//
//  Created by Windy on 29/03/22.
//

import UIKit

final class Label: UILabel {

    var insets: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    @discardableResult
    func insets(_ insets: UIEdgeInsets) -> Self {
        self.insets = insets
        return self
    }
    
    @discardableResult
    func apply(_ theme: LabelTheme) -> Self {
        LabelDecorator.apply(theme, for: self)
        return self
    }

}
