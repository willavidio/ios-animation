//
//  BasicCompositionViewController.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

private final class AnimationView: UIView {
    
    let textLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel.text = "👋"
        textLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        subtitleLabel.isHidden = true
        subtitleLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        let stackView = VStackView(alignment: .center) {
            textLabel
            subtitleLabel
        }.margin(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
       
        backgroundColor = .systemBackground
        
        layer.cornerRadius = 16
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        
        subtitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 64).isActive = true
       
        addSubview(stackView, constraints: .fill)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(animate))
        addGestureRecognizer(gesture)
    }
    
    private var isAnimated = false
    
    @objc
    private func animate() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if self?.isAnimated ?? false {
                self?.transform = .identity
                self?.subtitleLabel.isHidden = true
                self?.subtitleLabel.alpha = 0
            } else {
                self?.subtitleLabel.isHidden = false
                self?.subtitleLabel.alpha = 1
                self?.textLabel.transform = .identity
                self?.transform = .init(translationX: 0, y: -200)
            }
            self?.isAnimated.toggle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class BasicCompositionViewController: UIViewController {
    
    private let boxView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        boxView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boxView)

        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
}
