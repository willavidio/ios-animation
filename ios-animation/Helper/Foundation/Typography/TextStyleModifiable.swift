//
//  TextStyleModifiable.swift
//
//
//  Created by Windy on 12/10/22.
//

import Combine
import UIKit

// https://blog.eppz.eu/uilabel-line-height-letter-spacing-and-more-uilabel-typography-extensions/
protocol TextStyleModifiable: UILabel {
    var lineHeight: CGFloat? { get set }
    var letterSpacing: Double? { get set }
}

private var attributesKey: UInt = 0

extension UILabel: TextStyleModifiable {

    var lineHeight: CGFloat? {
        get {
            (attributes[.paragraphStyle] as? NSParagraphStyle)?.maximumLineHeight
        }
        set {
            let lineHeight = newValue ?? font.lineHeight
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.lineBreakMode = .byTruncatingTail

            let baselineOffset = (lineHeight - font.lineHeight) / 2.0
            attributes[.paragraphStyle] = paragraphStyle
            attributes[.baselineOffset] = baselineOffset
        }
    }

    var letterSpacing: Double? {
        get { attributes[.kern] as? Double }
        set { attributes[.kern] = newValue }
    }

    private var attributes: [NSAttributedString.Key: Any] {
        get {
            objc_getAssociatedObject(
                self,
                &attributesKey
            ) as? [NSAttributedString.Key: Any] ?? [:]
        }
        set {
            objc_setAssociatedObject(
                self,
                &attributesKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN
            )
        }
    }
    
}

private var textKey: UInt = 0

public extension UILabel {
    
    private var textPublisher: AnyCancellable? {
        get {
            objc_getAssociatedObject(self, &textKey) as? AnyCancellable
        }
        set(newValue) {
            objc_setAssociatedObject(self, &textKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @discardableResult
    func textStyle(_ textStyle: TextStyle) -> Self {
        applyTextStyle(textStyle)
        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
        setupTextPublisher()
        return self
    }
    
    private func applyTextStyle(_ textStyle: TextStyle) {
        font = textStyle.font
        lineHeight = textStyle.fontDescription.lineHeight
        letterSpacing = textStyle.fontDescription.letterSpacing
    }
    
    private func setupTextPublisher() {
        textPublisher = publisher(for: \.text)
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .replaceNil(with: "")
            .map { [weak self] in
                NSAttributedString(
                    string: $0,
                    attributes: self?.attributes
                        .updateTextAlignment(self?.textAlignment ?? .natural)
                )
            }
            .sink { [weak self] in self?.attributedText = $0 }
    }
}

private extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    func updateTextAlignment(_ alignment: NSTextAlignment) -> [NSAttributedString.Key: Any] {
        let newParagraphStyle = self[.paragraphStyle] as? NSMutableParagraphStyle
        newParagraphStyle?.alignment = alignment

        var newAttributes = self
        newAttributes[.paragraphStyle] = newParagraphStyle

        return newAttributes
    }
}
