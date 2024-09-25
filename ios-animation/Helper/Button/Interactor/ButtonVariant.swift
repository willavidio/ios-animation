//
//  ButtonVariant.swift
//  vidio
//
//  Created by Junita on 25/10/21.
//  Copyright © 2021 woi. All rights reserved.
//

import UIKit

/// Consists of title color, background color, ``Shadow``, and ``Border`` of the button.
///
/// This variant modifies only for normal, disabled, and highlighted states. Other states will use normal state.
public struct ButtonVariant {
    let normal: ButtonTheme
    let disabled: ButtonTheme
    let highlighted: ButtonTheme
    
    init(normal: ButtonTheme,
         disabled: ButtonTheme? = nil,
         highlighted: ButtonTheme? = nil) {
        self.normal = normal
        self.disabled = disabled ?? normal
        self.highlighted = highlighted ?? normal
    }
    
    /// Create custom variant for a button.
    /// - Parameters:
    ///   - normal: Theme to be applied when the button is on normal state
    ///   - disabled: Theme to be applied when the button is on disabled state
    ///   - highlighted: Theme to be applied when the button is on highlighted state
    ///
    ///  At a minimum, set the value for the normal state. If you don’t specify a theme for the other states, the button uses the theme associated with the normal state.
    public init(normal: CustomButtonTheme,
                disabled: CustomButtonTheme? = nil,
                highlighted: CustomButtonTheme? = nil) {
        self.normal = normal
        self.disabled = disabled ?? normal
        self.highlighted = highlighted ?? normal
    }
}

public struct CustomButtonTheme: ButtonTheme {
    let titleColor: UIColor?
    let backgroundColor: UIColor?
    let shadow: Shadow?
    let border: Border?
    
    public init(titleColor: UIColor?,
                backgroundColor: UIColor?,
                shadow: Shadow? = .base,
                border: Border? = nil) {
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.shadow = shadow
        self.border = border
    }
}

extension ButtonVariant {
    public static var primary = ButtonVariant(normal: PrimaryButtonTheme(),
                                       disabled: DisabledButtonTheme(),
                                       highlighted: PressedPrimaryButtonTheme())
    public static var secondary = ButtonVariant(normal: SecondaryButtonTheme(),
                                         disabled: DisabledButtonTheme(),
                                         highlighted: PressedSecondaryButtonTheme())
    public static var outlined = ButtonVariant(normal: OutlinedButtonTheme(),
                                        disabled: DisabledOutlinedButtonTheme(),
                                        highlighted: PressedOutlinedButtonTheme())
    public static var ghost = ButtonVariant(normal: GhostButtonTheme(),
                                     disabled: DisabledGhostButtonTheme(),
                                     highlighted: PressedGhostButtonTheme())
    public static var alternative = ButtonVariant(normal: AlternativeButtonTheme())
    public static var alternativeOutlined = ButtonVariant(normal: AlternativeOutlinedButtonTheme())
}
