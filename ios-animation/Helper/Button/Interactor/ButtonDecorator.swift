//
//  ButtonDecorator.swift
//  vidio
//
//  Created by Junita on 25/10/21.
//  Copyright © 2021 woi. All rights reserved.
//

import UIKit
import Combine

struct ButtonDecorator {
    static func apply(variant: ButtonVariant, for button: Button) {
        button.setTitleColor(variant.disabled.titleColor, for: .disabled)
        button.setTitleColor(variant.highlighted.titleColor, for: .highlighted)
        button.setTitleColor(variant.normal.titleColor, for: .normal)
        
        ViewDecorator.apply(theme: button.theme(for: variant), for: button)
        reapplyWhenNeeded(variant: variant, for: button)
        
        button.layoutIfNeeded()
    }
    
    static func set(size: ButtonSize, for button: Button) {
        button.titleLabel?.font = size.textStyle.font
        button.layer.cornerRadius = size.cornerRadius
        button.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                left: size.horizontalPadding,
                                                bottom: 0,
                                                right: size.horizontalPadding)
        button.contentVerticalAlignment = .center
        button.height = size.height
        button.iconSize = size.iconSize
        
        // we need to multiply the spacing by 2 to get the exact position we need
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(size.textToIconDistance * 2),
                                              bottom: 0, right: 0)
        button.invalidateIntrinsicContentSize()
        button.layoutIfNeeded()
        
        button.setImage(button.imageView?.image?.resize(to: size.iconSize), for: .normal)
    }
    
    static func set(icon: ButtonIcon?, for button: Button) {
        button.setImage(icon?.image?.resize(to: button.iconSize), for: .normal)
        button.tintColor = icon?.tintColor
        switch icon?.position {
        case .right:
            button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        case .left, .none:
            button.transform = .identity
            button.titleLabel?.transform = .identity
            button.imageView?.transform = .identity
        }
        button.layoutIfNeeded()
    }
}

private func reapplyWhenNeeded(variant: ButtonVariant, for button: Button) {
    button.cancellables.removeAll()
    button.publisher(for: \.isEnabled).map { _ in () }
        .receive(on: RunLoop.main)
        .sink(receiveValue: { [weak button] in
            guard let button = button else { return }
            ViewDecorator.apply(theme: button.theme(for: variant), for: button)
        })
        .store(in: &button.cancellables)
    
    button.publisher(for: \.isHighlighted)
        .receive(on: RunLoop.main)
        .sink(receiveValue: { [weak button] _ in
            guard let button = button else { return }
            UIView.animate(withDuration: 0.3, animations: {
                ViewDecorator.apply(theme: button.theme(for: variant), for: button)
            })
        })
        .store(in: &button.cancellables)
}

private extension Button {
    func theme(for variant: ButtonVariant) -> ViewTheme {
        switch (isEnabled, isHighlighted) {
        case (false, _): return variant.disabled
        case (true, false): return variant.normal
        case (true, true): return variant.highlighted
        }
    }
}

private extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        let currentRenderingMode = renderingMode
        let renderer = UIGraphicsImageRenderer(size: size)
        let scaledImage = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return scaledImage.withRenderingMode(currentRenderingMode)
    }
}
