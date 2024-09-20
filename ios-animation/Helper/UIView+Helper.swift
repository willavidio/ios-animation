//
//  UIView+Helper.swift
//  ios-animation
//
//  Created by Windy on 20/09/24.
//

import UIKit

extension UIView {
    
    enum ConstraintType {
        case fill
        case center
        case safeArea
        case bottomCenter
    }
    
    func addSubview(_ view: UIView, constraints type: ConstraintType) {
        addSubview(view)
        handleAutoLayout(type: type, for: view)
    }
    
    private func handleAutoLayout(type: ConstraintType, for view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .fill:
            view.fillToSuperview()
        case .center:
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        case .safeArea:
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
            ])
        case .bottomCenter:
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
    
    func fillToSuperview(margin: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(
                equalTo: superview.topAnchor,
                constant: margin.top),
            bottomAnchor.constraint(
                equalTo: superview.bottomAnchor,
                constant: -margin.bottom),
            leadingAnchor.constraint(
                equalTo: superview.leadingAnchor,
                constant: margin.left),
            trailingAnchor.constraint(
                equalTo: superview.trailingAnchor,
                constant: -margin.right),
        ])
    }
}
