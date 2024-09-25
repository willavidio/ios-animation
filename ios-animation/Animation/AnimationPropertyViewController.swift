import UIKit

final class AnimationPropertyViewController: UIViewController {
    
    private var isMoving = false
    private let boxView = BoxView(color: .red)
    
    // Sliders to control animation properties
    private lazy var durationSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.1
        slider.maximumValue = 3.0
        slider.value = 0.3
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var delaySlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 3.0
        slider.value = 0.0
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var dampingSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.1
        slider.maximumValue = 1.0
        slider.value = 0.7
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var velocitySlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 2.0
        slider.value = 1.0
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    // Segmented control for animation options
    private lazy var optionsSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["EaseIn", "EaseOut", "Linear"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(optionsChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    // Variables to track selected values
    private var selectedAnimationOption: UIView.AnimationOptions = .curveEaseIn
    
    // Button to trigger the animation
    private lazy var button = UIButton(configuration: .tinted())
        .title("Animate")
        .onTapAction { [weak self] in
            guard let self = self else { return }
            UIView.animate(
                withDuration: TimeInterval(self.durationSlider.value),
                delay: TimeInterval(self.delaySlider.value),
                usingSpringWithDamping: CGFloat(self.dampingSlider.value),
                initialSpringVelocity: CGFloat(self.velocitySlider.value),
                options: self.selectedAnimationOption,
                animations: { [weak self] in
                    if let isMoving = self?.isMoving, isMoving {
                        self?.boxView.transform = .init(translationX: 0, y: 100)
                    } else {
                        self?.boxView.transform = .init(translationX: 0, y: -100)
                    }
                    self?.isMoving.toggle()
                })
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(boxView, constraints: .center)
        view.addSubview(button, constraints: .bottomCenter)
        setupSliders()
    }
    
    // Setup the sliders and segmented control in a vertical stack
    private func setupSliders() {
        let stackView = UIStackView(arrangedSubviews: [
            createLabel(withText: "Duration"),
            durationSlider,
            createLabel(withText: "Delay"),
            delaySlider,
            createLabel(withText: "Damping Ratio"),
            dampingSlider,
            createLabel(withText: "Initial Velocity"),
            velocitySlider,
            createLabel(withText: "Animation Option"),
            optionsSegmentedControl
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // Helper method to create a label for each slider
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        return label
    }
    
    // Update values when a slider changes
    @objc private func sliderValueChanged(_ sender: UISlider) {
        // Optionally, print or update UI to reflect slider changes
        print("Duration: \(durationSlider.value), Delay: \(delaySlider.value), Damping: \(dampingSlider.value), Velocity: \(velocitySlider.value)")
    }
    
    // Change animation options based on segmented control selection
    @objc private func optionsChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedAnimationOption = .curveEaseIn
        case 1:
            selectedAnimationOption = .curveEaseOut
        case 2:
            selectedAnimationOption = .curveLinear
        default:
            selectedAnimationOption = .curveEaseIn
        }
    }
}
