//
//  BoxView.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

final class BoxView: UIView {
    
    init(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
