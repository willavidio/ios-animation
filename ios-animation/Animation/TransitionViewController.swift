//
//  TransitionViewController.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

final class TransitionViewController: UIViewController {
    
    enum Style: CaseIterable {
        case coverVertical
        case crossDissolve
        case flipHorizontal
        
        var style: UIModalTransitionStyle {
            switch self {
            case .coverVertical: return .coverVertical
            case .crossDissolve: return .crossDissolve
            case .flipHorizontal: return .flipHorizontal
            }
        }
        
        var title: String {
            switch self {
            case .coverVertical: return "Cover Vertical"
            case .crossDissolve: return "Cross Dissolve"
            case .flipHorizontal: return "Flip Horizontal"
            }
        }
    }
    
    private var style: UIModalTransitionStyle = .coverVertical
    
    private lazy var presentButton = UIButton(type: .system)
        .title("Present")
        .onTapAction { [weak self] in
            let vc = TargetViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = self?.style ?? .coverVertical
            self?.present(vc, animated: true)
        }
    
    private lazy var styleButton = UIButton(configuration: .tinted())
        .title("Cover Vertical")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        styleButton.showsMenuAsPrimaryAction = true
        styleButton.menu = UIMenu(children: Style.allCases.map { style in
            UIAction(title: style.title) { [weak self] _ in
                self?.style = style.style
                self?.styleButton.title(style.title)
            }
        })
        
        view.addSubview(VStackView {
            styleButton
            presentButton
        }, constraints: .center)
    }
    
}

private final class TargetViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let close = UIButton(configuration: .tinted())
        close.setTitle("Close", for: .normal)
        close.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        view.backgroundColor = .cyan
        
        view.addSubview(close, constraints: .center)
    }
}
