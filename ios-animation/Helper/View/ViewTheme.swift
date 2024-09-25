//
//  ViewTheme.swift
//  vidio
//
//  Created by Junita on 29/10/21.
//  Copyright © 2021 woi. All rights reserved.
//

import UIKit

protocol ViewTheme {
    var backgroundColor: UIColor? { get }
    var shadow: Shadow? { get }
    var border: Border? { get }
}
