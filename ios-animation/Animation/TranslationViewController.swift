//
//  TranslationViewController.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

final class TranslationViewController: UIViewController {
    
    private var isMoving = false
    private let boxView = BoxView(color: .red)
    private lazy var button = UIButton(type: .system)
        .title("Animate")
        .onTapAction { [weak self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let isMoving = self?.isMoving, isMoving {
                    self?.boxView.transform = .init(translationX: 0, y: 100)
                } else {
                    self?.boxView.transform = .init(translationX: 0, y: -100)
                }
                self?.isMoving.toggle()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boxView, constraints: .center)
        view.addSubview(button, constraints: .bottomCenter)
    }
}
