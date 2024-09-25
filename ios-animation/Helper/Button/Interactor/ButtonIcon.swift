//
//  ButtonIcon.swift
//  vidio
//
//  Created by Junita on 02/11/21.
//  Copyright © 2021 woi. All rights reserved.
//

import Foundation
import UIKit

/// Configuration to set icon for a button.
///
/// This configuration consists of the image of the icon and preferred position of the icon.
///  - Use ``ButtonIcon/left(_:)`` to set icon to be placed on left side
///  - Use ``ButtonIcon/right(_:)`` to set icon to be placed on right side
public struct ButtonIcon {
    public enum Position {
        case left
        case right
    }
    
    let position: Position
    let image: UIImage?
    let tintColor: UIColor?
}

extension ButtonIcon {
    public static func left(_ image: UIImage?, tintColor: UIColor? = nil) -> ButtonIcon {
        ButtonIcon(position: .left, image: image, tintColor: tintColor)
    }
    
    public static func right(_ image: UIImage?, tintColor: UIColor? = nil) -> ButtonIcon {
        ButtonIcon(position: .right, image: image, tintColor: tintColor)
    }
}
