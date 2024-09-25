//
//  ButtonTheme.swift
//  vidio
//
//  Created by Junita on 29/10/21.
//  Copyright © 2021 woi. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonTheme: ViewTheme {
    var titleColor: UIColor? { get }
}

struct PrimaryButtonTheme: ButtonTheme {
    let backgroundColor = UIColor(named: "btnBgPrimary")
    let titleColor = UIColor(named: "White")
    let shadow: Shadow? = .base
    let border: Border? = nil
}

struct PressedPrimaryButtonTheme: ButtonTheme {
    let backgroundColor = UIColor(named: "Red40")
    let titleColor = UIColor(named: "textDisabled")
    let shadow: Shadow? = .base
    let border: Border? = nil
}

struct SecondaryButtonTheme: ButtonTheme {
    let backgroundColor = UIColor(named: "BtnBgSecondary")
    let titleColor = UIColor(named: "Grey80")
    let shadow: Shadow? = .base
    let border: Border? = nil
}

struct PressedSecondaryButtonTheme: ButtonTheme {
    let backgroundColor = UIColor(named: "Grey10")
    let titleColor = UIColor(named: "Grey80")
    let shadow: Shadow? = .base
    let border: Border? = nil
}

struct DisabledButtonTheme: ButtonTheme {
    let backgroundColor = UIColor(named: "areaDisabled")
    let titleColor = UIColor(named: "textDisabled")
    let shadow: Shadow? = nil
    let border: Border? = nil
}

struct OutlinedButtonTheme: ButtonTheme {
    let backgroundColor: UIColor? = nil
    let titleColor = UIColor(named: "textPrimary")
    let shadow: Shadow? = nil
    let border: Border? = Border(color: UIColor(named: "BtnBgOutlined"), width: 1)
}

struct PressedOutlinedButtonTheme: ButtonTheme {
    let backgroundColor = UIColor(named: "Grey10")
    let titleColor = UIColor(named: "textPrimary")
    let shadow: Shadow? = nil
    let border: Border? = Border(color: UIColor(named: "BtnBgOutlined"), width: 1)
}

struct DisabledOutlinedButtonTheme: ButtonTheme {
    let backgroundColor: UIColor? = nil
    let titleColor = UIColor(named: "textDisabled")
    let shadow: Shadow? = nil
    let border: Border? = Border(color: UIColor(named: "separator"), width: 1)
}

struct GhostButtonTheme: ButtonTheme {
    let backgroundColor: UIColor? = nil
    let titleColor = UIColor(named: "textSecondary")
    let shadow: Shadow? = nil
    let border: Border? = nil
}

struct PressedGhostButtonTheme: ButtonTheme {
    let backgroundColor: UIColor? = nil
    let titleColor = UIColor(named: "Grey20")
    let shadow: Shadow? = nil
    let border: Border? = nil
}

struct DisabledGhostButtonTheme: ButtonTheme {
    let backgroundColor: UIColor? = nil
    let titleColor = UIColor(named: "textSecondary")
    let shadow: Shadow? = nil
    let border: Border? = nil
}

struct AlternativeButtonTheme: ButtonTheme {
    let backgroundColor = UIColor(named: "textLink")
    let titleColor = UIColor(named: "White")
    let shadow: Shadow? = nil
    let border: Border? = nil
}

struct AlternativeOutlinedButtonTheme: ButtonTheme {
    let backgroundColor: UIColor? = nil
    let titleColor = UIColor(named: "textLink")
    let shadow: Shadow? = nil
    let border: Border? = Border(color: UIColor(named: "textLink"), width: 1)
}
