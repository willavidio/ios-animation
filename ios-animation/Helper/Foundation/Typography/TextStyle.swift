//
//  AppFont.swift
//  vidio
//
//  Created by woi on 9/8/15.
//  Copyright © 2015 woi. All rights reserved.
//

import UIKit

public enum TextStyle {
    case title1
    case title2
    case title3
    case title4
    case body1
    case body2
    case smallTitle1
    case smallTitle2
    case smallTitle3
    case caption
    case tinyLabel
    case tinyBadge
}

public struct FontStyle {
    public let font: AppFont
    public let size: CGFloat
    public let letterSpacing: Double?
    public let lineHeight: CGFloat
    public let style: UIFont.TextStyle
}

public enum AppFont: String {
    case SFProDisplayHeavy = "SFProDisplay-Heavy"
    case SFProDisplayBold = "SFProDisplay-Bold"
    case SFProTextRegular = "SFProText-Regular"
    case SFProTextSemiBold = "SFProText-Semibold"
    case SFProTextBold = "SFProText-Bold"
    
    func font(size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
}

extension TextStyle {
    public var fontDescription: FontStyle {
        switch self {
        case .title1:
            return FontStyle(
                font: .SFProDisplayBold,
                size: 24,
                letterSpacing: 0.36,
                lineHeight: 31,
                style: .largeTitle)
        case .title2:
            return FontStyle(
                font: .SFProDisplayBold,
                size: 20,
                letterSpacing: 0.38,
                lineHeight: 28,
                style: .title1)
        case .title3:
            return FontStyle(
                font: .SFProTextBold,
                size: 16,
                letterSpacing: nil,
                lineHeight: 22,
                style: .title2)
        case .title4:
            return FontStyle(
                font: .SFProTextSemiBold,
                size: 16,
                letterSpacing: nil,
                lineHeight: 24,
                style: .title2)
        case .body1:
            return FontStyle(
                font: .SFProTextRegular,
                size: 16,
                letterSpacing: -0.32,
                lineHeight: 24,
                style: .body)
        case .body2:
            return FontStyle(
                font: .SFProTextRegular,
                size: 14,
                letterSpacing: -0.08,
                lineHeight: 21,
                style: .body)
        case .smallTitle1:
            return FontStyle(
                font: .SFProTextSemiBold,
                size: 14,
                letterSpacing: nil,
                lineHeight: 19,
                style: .title3)
        case .smallTitle2:
            return FontStyle(
                font: .SFProTextSemiBold,
                size: 13,
                letterSpacing: nil,
                lineHeight: 18,
                style: .title3)
        case .smallTitle3:
            return FontStyle(
                font: .SFProTextSemiBold,
                size: 12,
                letterSpacing: nil,
                lineHeight: 18,
                style: .title3)
        case .caption:
            return FontStyle(
                font: .SFProTextRegular,
                size: 12,
                letterSpacing: nil,
                lineHeight: 18,
                style: .caption1)
        case .tinyLabel:
            return FontStyle(
                font: .SFProTextSemiBold,
                size: 10,
                letterSpacing: nil,
                lineHeight: 14,
                style: .title3)
        case .tinyBadge:
            return FontStyle(
                font: .SFProTextBold,
                size: 8,
                letterSpacing: nil,
                lineHeight: 10,
                style: .caption2)
        }
    }
}

extension TextStyle {
    public var font: UIFont {
        guard let font = UIFont(name: fontDescription.font.rawValue, size: fontDescription.size)
        else {
            return UIFont.preferredFont(forTextStyle: fontDescription.style)
        }
        let fontMetrics = UIFontMetrics(forTextStyle: fontDescription.style)
        return fontMetrics.scaledFont(for: font)
    }
}
