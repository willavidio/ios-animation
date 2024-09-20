//
//  RotationViewController.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

final class RotationViewController: UIViewController {
    
    private var isRotate = false
    private let boxView = BoxView(color: .red)
    private lazy var button = UIButton(type: .system)
        .title("Animate")
        .onTapAction { [weak self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let isRotate = self?.isRotate, isRotate {
                    self?.boxView.transform = .identity
                } else {
                    self?.boxView.transform = .init(rotationAngle: 180)
                }
                self?.isRotate.toggle()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boxView, constraints: .center)
        view.addSubview(button, constraints: .bottomCenter)
    }
}
