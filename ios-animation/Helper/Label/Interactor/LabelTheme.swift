//
//  LabelTheme.swift
//  
//
//  Created by Windy on 23/03/22.
//

import UIKit

/// Configuration for a Label style.
public struct LabelTheme {
    let textStyle: TextStyle
    let textColor: UIColor?
    
    public init(textStyle: TextStyle, textColor: UIColor?) {
        self.textStyle = textStyle
        self.textColor = textColor
    }
}

extension LabelTheme {
    
    var fontStyle: FontStyle {
        return textStyle.fontDescription
    }
    
}

extension LabelTheme {
    
    static let title2Primary = LabelTheme(
        textStyle: .title2,
        textColor: .textPrimary)
    static let smallTitle1Primary = LabelTheme(
        textStyle: .smallTitle1,
        textColor: .textPrimary)
    static let smallTitle1Helper = LabelTheme(
        textStyle: .smallTitle1,
        textColor: .textHelper)
    static let body2Secondary = LabelTheme(
        textStyle: .body2,
        textColor: .textSecondary)
    static let captionSecondary = LabelTheme(
        textStyle: .caption,
        textColor: .textSecondary)
    static let captionHelper = LabelTheme(
        textStyle: .caption,
        textColor: .textHelper)
    static let captionError = LabelTheme(
        textStyle: .caption,
        textColor: .textError)
    
}
