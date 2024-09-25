//
//  ButtonSize.swift
//  vidio
//
//  Created by Junita on 26/10/21.
//  Copyright © 2021 woi. All rights reserved.
//

import UIKit

/// Consist of textStyle, height, cornerRadius, horizontalPadding and textToIconDistance of the button size
public struct ButtonSize {
    let textStyle: TextStyle
    let height: CGFloat
    let cornerRadius: CGFloat
    let horizontalPadding: CGFloat
    let textToIconDistance: CGFloat
    let iconSize: CGSize
    
    /// Create custom size for a button
    /// - Parameters:
    ///   - textStyle: TextStyle for the button
    ///   - height: Height for the button
    ///   - cornerRadius: Corner radius for the button
    ///   - horizontalPadding: Set the left and right content edge insets for the button
    ///   - textToIconDistance: Distance of the button's title to icon when icon is available
    public init(textStyle: TextStyle,
                height: CGFloat,
                cornerRadius: CGFloat = 4,
                horizontalPadding: CGFloat,
                textToIconDistance: CGFloat = 4,
                iconSize: CGSize = .init(width: 16, height: 16)) {
        self.textStyle = textStyle
        self.height = height
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.textToIconDistance = textToIconDistance
        self.iconSize = iconSize
    }
}

extension ButtonSize {
    public static var small = ButtonSize(
        textStyle: .smallTitle3,
        height: 32,
        horizontalPadding: 12,
        iconSize: .init(width: 16, height: 16)
    )
    public static var medium = ButtonSize(
        textStyle: .title3,
        height: 40,
        horizontalPadding: 24,
        iconSize: .init(width: 16, height: 16)
    )
    public static var large = ButtonSize(
        textStyle: .title3,
        height: 48,
        horizontalPadding: 24,
        iconSize: .init(width: 24, height: 24)
    )
}
