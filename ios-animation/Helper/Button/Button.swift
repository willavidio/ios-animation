//
//  VidiButton.swift
//  
//
//  Created by Junita on 11/02/22.
//

import UIKit
import Combine

public final class Button: UIButton {
    var cancellables = Set<AnyCancellable>()
    var height: CGFloat?
    var iconSize: CGSize = .init(width: 16, height: 16)
    
    private var activeVariant: ButtonVariant?
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard let activeVariant else { return }
        ButtonDecorator.apply(variant: activeVariant, for: self)
    }
    
    @discardableResult
    public func size(_ size: ButtonSize) -> Self {
        ButtonDecorator.set(size: size, for: self)
        return self
    }
    
    @discardableResult
    public func variant(_ variant: ButtonVariant) -> Self {
        ButtonDecorator.apply(variant: variant, for: self)
        if #available(iOS 17.0, *) {
            handleUserInterfaceStyleChanged(for: variant)
        } else {
            activeVariant = variant
        }
        return self
    }
    
    private func handleUserInterfaceStyleChanged(for variant: ButtonVariant) {
        guard #available(iOS 17.0, *) else { return }
        
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { (self: Self, previousTraitCollection: UITraitCollection)  in
            ButtonDecorator.apply(variant: variant, for: self)
        }
    }
    
    /// Make sure that the icon used is in the right size according to the button size.
    /// For small button, we need 16 px x 16 px image.
    /// For medium and large button, we need 24 px x 24 px image.
    @discardableResult
    public func icon(_ icon: ButtonIcon?) -> Self {
        ButtonDecorator.set(icon: icon, for: self)
        return self
    }
    
    public override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width +=
            (self.contentEdgeInsets.left + self.contentEdgeInsets.right) / 2.0
        intrinsicContentSize.width +=
            (self.imageEdgeInsets.left + self.imageEdgeInsets.right) / 2.0
        intrinsicContentSize.width +=
            (self.titleEdgeInsets.left + self.titleEdgeInsets.right) / 2.0
        
        return CGSize(width: intrinsicContentSize.width,
                      height: height ?? intrinsicContentSize.height)
    }
}

