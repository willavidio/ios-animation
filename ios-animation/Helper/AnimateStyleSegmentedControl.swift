//
//  AnimateStyleSegmentedControl.swift
//  ios-animation
//
//  Created by VIDIO on 24/09/24.
//

import UIKit

enum SegmentOption {
    case basic
    case spring
}

class AnimationOptionSegmentedControl {
    private let segmentedControl: UISegmentedControl
    private var selectionChanged: ((SegmentOption) -> Void)?
    
    init(options: [SegmentOption]) {
        let items = options.map { $0.displayName() }
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    func configure(in view: UIView, completion: @escaping (SegmentOption) -> Void) {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup layout constraints
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        self.selectionChanged = completion
    }
    
    @objc private func segmentChanged() {
        let selectedSegment = segmentedControl.selectedSegmentIndex
        let option: SegmentOption = selectedSegment == 0 ? .basic : .spring
        selectionChanged?(option)
    }
}

extension SegmentOption {
    func displayName() -> String {
        switch self {
        case .basic:
            return "Basic"
        case .spring:
            return "Spring"
        }
    }
}
