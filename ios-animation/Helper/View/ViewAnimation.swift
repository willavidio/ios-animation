//
//  File.swift
//  
//
//  Created by VIDIO on 16/09/24.
//

import UIKit

public protocol Animatable {
    func animate(onComplete: @escaping () -> Void)
}

public extension Animatable {
    func animate() {
        animate(onComplete: {})
    }
}

public extension UIView {
    enum AnimationDirection {
        case up, down, left, right
    }
    
    func move(_ direction: AnimationDirection, by value: CGFloat) -> ViewAnimation {
        switch direction {
        case .up: return move(by: .init(x: 0, y: -value))
        case .down: return move(by: .init(x: 0, y: value))
        case .left: return move(by: .init(x: -value, y: 0))
        case .right: return move(by: .init(x: value, y: 0))
        }
    }
    
    func move(by point: CGPoint) -> ViewAnimation {
        ViewAnimation {
            self.transform = self.transform.translatedBy(x: point.x, y: point.y)
        }
    }
    
    enum SlideAnimationLocation {
        case left
        case right
        case top
        case bottom
    }
    func slideIn(from location: SlideAnimationLocation) -> Animatable {
        DeferredAnimation { [weak self] in
            guard let self = self, let superview = self.superview
            else { return nil }
            
            let parentWidth = superview.frame.width
            let parentHeight = superview.frame.height
            
            switch location {
            case .left:
                self.transform = self.transform.translatedBy(x: -parentWidth, y: 0)
                return self.move(.right, by: parentWidth)
            case .right:
                self.transform = self.transform.translatedBy(x: parentWidth, y: 0)
                return self.move(.left, by: parentWidth)
            case .top:
                self.transform = self.transform.translatedBy(x: 0, y: -parentHeight)
                return self.move(.down, by: parentHeight)
            case .bottom:
                self.transform = self.transform.translatedBy(x: 0, y: parentHeight)
                return self.move(.up, by: parentHeight)
            }
        }
    }
    
    func slideOut(to location: SlideAnimationLocation) -> Animatable {
        DeferredAnimation { [weak self] in
            guard let self = self, let superview = self.superview
            else { return nil }
            
            let parentWidth = superview.frame.width
            let parentHeight = superview.frame.height
            
            switch location {
            case .left:
                return self.move(.left, by: parentWidth)
            case .right:
                return self.move(.right, by: parentWidth)
            case .top:
                return self.move(.up, by: parentHeight)
            case .bottom:
                return self.move(.down, by: parentHeight)
            }
        }
    }
    
    func identity() -> ViewAnimation {
        ViewAnimation {
            self.transform = .identity
        }
    }
    
    func scale(_ scale: CGFloat) -> ViewAnimation {
        ViewAnimation {
            self.transform = self.transform.scaledBy(x: scale, y: scale)
        }
    }
    
    func corner(_ value: CGFloat) -> ViewAnimation {
        ViewAnimation {
            self.cornerRadius(value)
        }
    }
    
    func animateIsHidden(_ isHidden: Bool) -> ViewAnimation {
        ViewAnimation {
            if self.isHidden != isHidden {
                self.isHidden = isHidden
            }
        }
    }
}

public extension ViewAnimation {
    static func serial(
        @ViewAnimationsBuilder _ block: () -> [Animatable],
        onComplete: @escaping () -> Void = {}
    ) {
        return SerialViewAnimations(animations: block).animate(onComplete: onComplete)
    }

    static func parallel(
        @ViewAnimationsBuilder _ block: () -> [Animatable],
        onComplete: @escaping () -> Void = {}
    ) {
        return ParallelViewAnimations(animations: block).animate(onComplete: onComplete)
    }
}

public struct NonAnimatingAction: Animatable {
    private let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func animate(onComplete: @escaping () -> Void) {
        action()
        onComplete()
    }
}

public struct ViewAnimation: Animatable {
    private let delay: TimeInterval
    private let animations: () -> Void
    private let damping: CGFloat
    private let response: CGFloat
    
    public init(
        damping: CGFloat = 1.0,
        response: CGFloat = 0.3,
        delay: TimeInterval = 0,
        animations: @escaping () -> Void
    ) {
        self.damping = damping
        self.response = response
        self.delay = delay
        self.animations = animations
    }
    
    public func animate(onComplete: @escaping () -> Void) {
        UIView.springAnimate(
            damping: damping,
            response: response,
            delay: delay,
            animations: animations,
            completion: onComplete
        )
    }
}

public protocol GroupedViewAnimations {
    init(animations: [Animatable])
}

public struct SerialViewAnimations: Animatable, GroupedViewAnimations {
    private let animations: [Animatable]
    
    public init(animations: [Animatable]) {
        self.animations = animations
    }
    
    public func animate(onComplete: @escaping () -> Void) {
        animate(animations, onComplete: onComplete)
    }
    
    private func animate(_ animations: [Animatable], onComplete: @escaping () -> Void) {
        guard !animations.isEmpty
        else {
            onComplete()
            return
        }
        
        var animations = animations
        let animation = animations.removeFirst()
        
        animation.animate {
            animate(animations, onComplete: onComplete)
        }
    }
}

public struct ParallelViewAnimations: Animatable, GroupedViewAnimations {
    private let animations: [Animatable]
    
    public init(animations: [Animatable]) {
        self.animations = animations
    }
    
    public func animate(onComplete: @escaping () -> Void) {
        guard !animations.isEmpty
        else {
            onComplete()
            return
        }
        
        var completeCount = 0
        animations.forEach { animation in
            animation.animate {
                completeCount += 1
                if completeCount >= animations.count {
                    onComplete()
                }
            }
        }
    }
}

public struct DeferredAnimation: Animatable {
    private let animation: () -> Animatable?
    
    public init(_ block: @escaping () -> Animatable?) {
        animation = block
    }
    
    public func animate(onComplete: @escaping () -> Void) {
        guard let animation = animation() else {
            onComplete()
            return
        }
        animation.animate(onComplete: onComplete)
    }
}

public extension GroupedViewAnimations {
    init(@ViewAnimationsBuilder animations: () -> [Animatable]) {
        self.init(animations: animations())
    }
}

@resultBuilder
public struct ViewAnimationsBuilder {
    static public func buildBlock(_ animations: Animatable?...) -> [Animatable] {
        return animations.compactMap { $0 }
    }
}

public extension UIView {
    static func springAnimate(
        damping: CGFloat = 1.0,
        response: CGFloat = 0.3,
        delay: TimeInterval = 0,
        animations: @escaping () -> Void,
        completion: (() -> Void)? = nil
    ) {
        let spring = UISpringTimingParameters(damping: damping, response: response)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: spring)
        animator.addAnimations(animations)
        animator.addCompletion { _ in completion?() }
        animator.startAnimation(afterDelay: delay)
    }
}

extension UISpringTimingParameters {
    
    /// A design-friendly way to create a spring timing curve.
    ///
    /// - Parameters:
    ///   - damping: The 'bounciness' of the animation. Value must be between 0 and 1.
    ///   - response: The 'speed' of the animation.
    ///   - initialVelocity: The vector describing the starting motion of the property.
    ///   Optional, default is `.zero`.
    ///
    ///   https://medium.com/@nathangitter/building-fluid-interfaces-ios-swift-9732bb934bf5
    convenience init(
        damping: CGFloat,
        response: CGFloat,
        initialVelocity: CGVector = .zero
    ) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
    
}
