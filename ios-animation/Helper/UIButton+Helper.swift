//
//  UIButton+Helper.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

extension UIButton {
    
    @discardableResult
    func title(_ text: String?, with state: UIControl.State = .normal) -> Self {
        self.setTitle(text, for: state)
        titleLabel?.font = .preferredFont(forTextStyle: .title3)
        return self
    }
   
    @discardableResult
    func onTapAction(_ addTapAction: @escaping () -> Void) -> Self {
        addAction(UIAction(handler: { _ in
            addTapAction()
        }), for: .touchUpInside)
        return self
    }
}
