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
    
    enum PresentationStyle: CaseIterable {
        case fullScreen
        case pageSheet
        
        var style: UIModalPresentationStyle {
            return switch self {
            case .fullScreen: .fullScreen
            case .pageSheet: .pageSheet
            }
        }
        
        var title: String {
            return switch self {
            case .fullScreen: "Full Screen"
            case .pageSheet: "Page Sheet"
            }
        }
    }
    
    private var style: UIModalTransitionStyle = .coverVertical
    private var modalPresentation: UIModalPresentationStyle = .fullScreen
    
    private lazy var presentButton = UIButton(type: .system)
        .title("Present")
        .onTapAction { [weak self] in
            let vc = TargetViewController()
            vc.modalPresentationStyle = self?.modalPresentation ?? .fullScreen
            vc.modalTransitionStyle = self?.style ?? .coverVertical
            self?.present(vc, animated: true)
        }
    
    private lazy var modalTransitionStyleButton = UIButton(configuration: .tinted())
        .title("Transition: Cover Vertical")
    
    private lazy var modalPresentationStyleButton = UIButton(configuration: .tinted())
        .title("Presentation: FullScreen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        modalTransitionStyleButton.showsMenuAsPrimaryAction = true
        modalTransitionStyleButton.menu = UIMenu(children: Style.allCases.map { style in
            UIAction(title: style.title) { [weak self] _ in
                self?.style = style.style
                self?.modalTransitionStyleButton.title("Transition:" + style.title)
            }
        })
        
        modalPresentationStyleButton.showsMenuAsPrimaryAction = true
        modalPresentationStyleButton.menu = UIMenu(children: PresentationStyle.allCases.map { style in
            UIAction(title: style.title) { [weak self] _ in
                self?.modalPresentation = style.style
                self?.modalPresentationStyleButton.title("Presentation:" + style.title)
            }
        })
        
        view.addSubview(VStackView(spacing: 4) {
            modalTransitionStyleButton
            modalPresentationStyleButton
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
