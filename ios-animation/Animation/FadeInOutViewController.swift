//
//  FadeInOutViewController.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

final class FadeInOutViewController: UIViewController {
    
    private let boxView = BoxView(color: .red)
    private lazy var button = UIButton(type: .system)
        .title("Animate")
        .onTapAction { [weak self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                if self?.boxView.alpha == 1 {
                    self?.boxView.alpha = 0
                } else {
                    self?.boxView.alpha = 1
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boxView, constraints: .center)
        view.addSubview(button, constraints: .bottomCenter)
    }
}
