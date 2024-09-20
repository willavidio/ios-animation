//
//  ScaleViewController.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

final class ScaleViewController: UIViewController {
    
    private var isScaling = false
    private let boxView = BoxView(color: .red)
    private lazy var button = UIButton(configuration: .tinted())
        .title("Animate")
        .onTapAction { [weak self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let isScaling = self?.isScaling, isScaling {
                    self?.boxView.transform = .identity
                } else {
                    self?.boxView.transform = .init(scaleX: 1.5, y: 1.5)
                }
                self?.isScaling.toggle()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boxView, constraints: .center)
        view.addSubview(button, constraints: .bottomCenter)
    }
}
