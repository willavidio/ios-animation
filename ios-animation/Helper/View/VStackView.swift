//
//  VStackView.swift
//  
//
//  Created by Windy on 15/08/23.
//

import UIKit

public final class VStackView: UIStackView {
    
    public init(
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment? = nil,
        distribution: UIStackView.Distribution? = nil,
        @ViewBuilder arrangedSubviews: () -> [UIView]
    ) {
        super.init(frame: .zero)
        axis = .vertical
        self.spacing = spacing

        arrangedSubviews().forEach(addArrangedSubview)

        if let alignment {
            self.alignment = alignment
        }
        
        if let distribution {
            self.distribution = distribution
        }
    }
   
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
