//
//  FloatingMenu.swift
//  ios-animation
//
//  Created by VIDIO on 24/09/24.
//

import UIKit

public struct FloatingMenuButton {
    
    let button: Button

    public init(
        image: UIImage,
        title: String,
        action: @escaping () -> Void
    ) {
        self.button = Button()
            .variant(.floatingMenuButton)
            .size(.smallRounded)
            .icon(.left(image))
            .title(title)
            .onTapAction(action)
    }
}

public final class FloatingMenu: UIView {
    
    @objc
    private func showFloatingMenu() {
        showAnimate(animationType: .noAnimation)
    }
    
    @objc
    private func onTapOverlayView() {
        dismiss(animationType: .noAnimation)
    }
    
    public enum AnimationType {
        case noAnimation
        case animation
        case springAnimation
    }
    
    public struct Configuration {
        let titleLabelTheme: LabelTheme
        let imageContentMode: UIView.ContentMode
        let imageAndTitleStackAlignment: UIStackView.Alignment
        let imageAndTitleStackMargin: UIEdgeInsets
        let imageAndTitleSpacing: CGFloat
        let floatingMenuButtonSpacing: CGFloat
        
        public init(
            titleLabelTheme: LabelTheme = .init(textStyle: .tinyLabel, textColor: .black),
            imageContentMode: UIView.ContentMode = .scaleAspectFit,
            imageAndTitleStackAlignment: UIStackView.Alignment = .center,
            imageAndTitleStackMargin: UIEdgeInsets = .zero,
            imageAndTitleSpacing: CGFloat = 4,
            floatingMenuButtonSpacing: CGFloat = 8
        ) {
            self.titleLabelTheme = titleLabelTheme
            self.imageContentMode = imageContentMode
            self.imageAndTitleSpacing = imageAndTitleSpacing
            self.imageAndTitleStackAlignment = imageAndTitleStackAlignment
            self.imageAndTitleStackMargin = imageAndTitleStackMargin
            self.floatingMenuButtonSpacing = floatingMenuButtonSpacing
        }
    }

    private lazy var titleLabel = Label().apply(configuration.titleLabelTheme)
    private lazy var imageView = UIImageView().contentMode(configuration.imageContentMode)
    private lazy var overlayView = UIView()
        .backgroundColor(.black.withAlphaComponent(0.6))
        .alpha(0)
        .addGesture(UITapGestureRecognizer(target: self, action: #selector(onTapOverlayView)))
    private lazy var imageAndTitleStack = VStackView(
        spacing: configuration.imageAndTitleSpacing,
        alignment: configuration.imageAndTitleStackAlignment
    ) {
        imageView
        titleLabel
    }.margin(configuration.imageAndTitleStackMargin)
    
    private lazy var floatingMenuButtonStack = VStackView(
        spacing: configuration.floatingMenuButtonSpacing,
        alignment: .leading,
        distribution: .fillEqually,
        arrangedSubviews: { }
    ).translatesAutoresizingMaskIntoConstraints(false)
    
    private var configuration = Configuration() {
        didSet { applyConfiguration(configuration) }
    }
    private var floatingMenuButtons: [FloatingMenuButton] = [] {
        didSet {
            floatingMenuButtonStack.removeAllArrangedSubviews()
            floatingMenuButtonStack.addArrangedSubviews(floatingMenuButtons.map { $0.button })
        }
    }
    private var floatingMenuButtonSpacing: CGFloat {
        get { floatingMenuButtonStack.spacing }
        set { floatingMenuButtonStack.spacing = newValue }
    }
    
    private weak var parentView: UIView?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    @discardableResult
    public func configuration(_ configuration: Configuration) -> Self {
        self.configuration = configuration
        return self
    }

    @discardableResult
    public func image(_ image: UIImage) -> Self {
        imageView.image(image)
        return self
    }

    @discardableResult
    public func title(_ title: String) -> Self {
        titleLabel.text = title
        return self
    }
    
    @discardableResult
    public func parentView(_ parentView: UIView) -> Self {
        self.parentView = parentView
        return self
    }
    
    @discardableResult
    public func floatingMenuButtons(_ buttons: [FloatingMenuButton]) -> Self {
        self.floatingMenuButtons = buttons
        return self
    }

    public func dismiss(animationType: AnimationType) {
        switch animationType {
        case .noAnimation:
            overlayView.removeFromSuperview()
            floatingMenuButtonStack.removeFromSuperview()
        case .animation:
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.stackFloatingMenuButtonsToCenter()
                self?.overlayView.alpha = 0
            } completion: { [weak self] _ in
                self?.overlayView.removeFromSuperview()
                self?.floatingMenuButtonStack.removeFromSuperview()
            }
        case .springAnimation:
            ViewAnimation.parallel {
                ViewAnimation { [weak self] in
                    self?.stackFloatingMenuButtonsToCenter()
                }
                ViewAnimation { [weak self] in
                    self?.overlayView.alpha = 0
                }
            } onComplete: { [weak self] in
                self?.overlayView.removeFromSuperview()
                self?.floatingMenuButtonStack.removeFromSuperview()
            }
        }
    }

    private func configureView() {
        backgroundColor = .clear
        addSubview(imageAndTitleStack, constraints: .fill)
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(showFloatingMenu)
            )
        )
    }
    
    private func applyConfiguration(_ configuration: Configuration) {
        titleLabel.apply(configuration.titleLabelTheme)
        imageView.contentMode = configuration.imageContentMode
        imageAndTitleStack.spacing = configuration.imageAndTitleSpacing
        imageAndTitleStack.alignment = configuration.imageAndTitleStackAlignment
        imageAndTitleStack.margin(configuration.imageAndTitleStackMargin)
        floatingMenuButtonSpacing = configuration.floatingMenuButtonSpacing
    }

    private func configureFloatingMenuButtons() {
        guard let parentView else { return }
        parentView.addSubview(overlayView, constraints: .fill)
        overlayView.addSubview(floatingMenuButtonStack)

        let distanceFromParent = convert(bounds.origin, to: parentView)
        NSLayoutConstraint.activate([
            floatingMenuButtonStack.leadingAnchor.constraint(
                equalTo: overlayView.leadingAnchor, constant: distanceFromParent.x
            ),
            floatingMenuButtonStack.centerYAnchor.constraint(
                equalTo: overlayView.topAnchor, constant: distanceFromParent.y + frame.height / 2
            )
        ])
    }

    private func animateSpreadFloatingMenuButtons(animationType: AnimationType) {
        let buttons = floatingMenuButtons.map { $0.button }
        switch animationType {
        case .noAnimation:
            buttons.forEach { $0.transform = .identity }
            overlayView.alpha = 1
        case .animation:
            UIView.animate(withDuration: 0.3) { [weak self] in
                buttons.forEach { $0.transform = .identity }
                self?.overlayView.alpha = 1
            }
        case .springAnimation:
            ViewAnimation.parallel {
                ParallelViewAnimations(animations: buttons.map { $0.identity() })
                ViewAnimation { [weak self] in self?.overlayView.alpha = 1 }
            }
        }
    }
    
    private func stackFloatingMenuButtonsToCenter() {
        let buttons = floatingMenuButtons.map { $0.button }
        let spacing = floatingMenuButtonSpacing
        if buttons.count.isEven {
            let middleIndex = buttons.count / 2
            let top = Array(buttons.prefix(middleIndex))
            let bottom = Array(buttons.suffix(from: middleIndex))

            for (index, button) in top.enumerated() {
                let lastIndex = top.count - 1
                let distance = button.frame.height + spacing
                let distanceMultiplier = CGFloat(lastIndex - index)
                let totalDistance = distanceMultiplier * distance + distance / 2

                button.transform = .init(translationX: 0, y: totalDistance)
            }
            for (index, button) in bottom.enumerated() {
                let distance = button.frame.height + spacing
                let totalDistance = CGFloat(index) * distance + distance / 2
                button.transform = .init(translationX: 0, y: -totalDistance)
            }
        } else {
            let middleIndex = buttons.count / 2
            let top = Array(buttons.prefix(middleIndex))
            let bottom = Array(buttons.suffix(from: middleIndex + 1))

            for (index, button) in top.enumerated() {
                let distance = button.frame.height + spacing
                let distanceMultiplier = CGFloat(middleIndex - index)
                let totalDistance = distanceMultiplier * distance

                button.transform = .init(translationX: 0, y: totalDistance)
            }
            for (index, button) in bottom.enumerated() {
                let distance = button.frame.height + spacing
                let distanceMultiplier = CGFloat(middleIndex - index)
                let totalDistance = distanceMultiplier * distance

                button.transform = .init(translationX: 0, y: -totalDistance)
            }
        }
    }
    
    private func showAnimate(animationType: AnimationType) {
        configureFloatingMenuButtons()
        stackFloatingMenuButtonsToCenter()
        animateSpreadFloatingMenuButtons(animationType: animationType)
    }
}

private extension Int {
    var isEven: Bool { self % 2 == 0 }
}

private extension Array {
    func element(at index: Int) -> Element? {
        guard index >= 0 && count > index else { return nil }
        return self[index]
    }
}

private extension ButtonVariant {
    static let floatingMenuButton = ButtonVariant(
        normal: .init(titleColor: .textPrimary, backgroundColor: .uiBackground2, shadow: .base)
    )
}

private extension ButtonSize {
    static let smallRounded = ButtonSize(
        textStyle: .smallTitle3,
        height: 32,
        cornerRadius: 32 / 2,
        horizontalPadding: 12,
        iconSize: .init(width: 16, height: 16)
    )
}

