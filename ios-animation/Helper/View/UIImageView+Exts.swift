//
//  UIImageView+Exts.swift
//
//
//  Created by Windy on 29/07/24.
//

import UIKit

public extension UIImageView {
    
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
}
