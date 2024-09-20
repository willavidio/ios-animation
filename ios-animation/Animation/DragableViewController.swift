//
//  DragableViewController.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit
import Foundation

final class DragableViewController: UIViewController {
   
    private lazy var positionPolicy = PositionPolicy(
        size: CGSize(width: 100, height: 100),
        superviewBounds: { self.container.bounds }
    )
    
    private let container = UIView()
    private let boxView = BoxView(color: .red)
    
    enum Style: CaseIterable {
        case doNothing
        case snapToEdge
        case snapToCenter
        case fallingDown
        
        var title: String {
            switch self {
            case .doNothing: return "Do Nothing"
            case .snapToEdge: return "Snap to Edge"
            case .snapToCenter: return "Snap to Center"
            case .fallingDown: return "Falling Down"
            }
        }
    }
    
    private var selectedStyle: Style = .doNothing

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(container, constraints: .safeArea)
        container.addSubview(boxView, constraints: .center)
        boxView.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(handleGesture)
        ))

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Style",
            menu: UIMenu(options: [.singleSelection], children: Style.allCases.map { style in
                UIAction(
                    title: style.title,
                    state: selectedStyle == style ? .on : .off
                ) { [weak self] _ in
                    self?.selectedStyle = style
                }
            })
        )
    }
    
    @objc
    private func handleGesture(_ sender: UIPanGestureRecognizer) {
        guard let superview = sender.view?.superview else { return }
        let location = sender.location(in: superview)
        
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.3) {
                self.boxView.transform = .init(scaleX: 1.3, y: 1.3)
            }
        case .changed:
            boxView.center = positionPolicy.onChanged(location)
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.3) {
                self.boxView.transform = .identity
            }
            
            switch selectedStyle {
            case .doNothing:
                break
            case .fallingDown:
                UIView.animate(withDuration: 0.3) {
                    self.boxView.center.y = self.container.bounds.maxY - 50
                }
            case .snapToEdge:
                UIView.animate(withDuration: 0.3) {
                    self.boxView.center = self.positionPolicy.onEnded(sender.view?.center ?? .zero)
                }
            case .snapToCenter:
                UIView.animate(withDuration: 0.3) {
                    self.boxView.center = CGPoint(
                        x: self.container.center.x,
                        y: self.container.center.y - 50
                    )
                }
            }
        default:
            break
        }
    }
}

private struct PositionPolicy {
    
    private let size: CGSize
    private let superviewBounds: () -> CGRect
    
    init(size: CGSize, superviewBounds: @escaping () -> CGRect) {
        self.size = size
        self.superviewBounds = superviewBounds
    }
    
    private var minX: CGFloat {
        superviewBounds().minX + size.width / 2
    }
    
    private var midX: CGFloat {
        superviewBounds().width / 2
    }
    
    private var maxX: CGFloat {
        superviewBounds().width - size.width / 2
    }
    
    private var minY: CGFloat {
        superviewBounds().minY + size.height / 2
    }
    
    private var maxY: CGFloat {
        superviewBounds().height - size.height / 2
    }
    
    func onChanged(_ newCenter: CGPoint) -> CGPoint {
        CGPoint(
            x: min(max(newCenter.x, minX), maxX),
            y: min(max(newCenter.y, minY), maxY)
        )
    }
    
    func onEnded(_ newCenter: CGPoint) -> CGPoint {
        CGPoint(
            x: newCenter.x <= midX ? minX : maxX,
            y: newCenter.y
        )
    }
}
