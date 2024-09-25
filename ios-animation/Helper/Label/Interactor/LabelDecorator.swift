//
//  LabelDecorator.swift
//  
//
//  Created by Windy on 23/03/22.
//

import UIKit

struct LabelDecorator {
    
    static func apply(_ theme: LabelTheme, for label: Label) {
        label.font = theme.textStyle.font
        label.textColor = theme.textColor
        applyFontStyle(theme.fontStyle, for: label)
    }
    
    static private func applyFontStyle(_ fontStyle: FontStyle, for label: Label) {
        label.letterSpacing = fontStyle.letterSpacing
        label.lineHeight = fontStyle.lineHeight
    }
    
}
