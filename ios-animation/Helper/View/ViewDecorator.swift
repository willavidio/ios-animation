//
//  ViewDecorator.swift
//  vidio
//
//  Created by Junita on 29/10/21.
//  Copyright © 2021 woi. All rights reserved.
//

import UIKit

struct ViewDecorator {
    static func apply(theme: ViewTheme, for view: UIView) {
        view.backgroundColor = theme.backgroundColor
        view.shadow(theme.shadow ?? .none)
            .border(theme.border ?? .none)
    }
}
