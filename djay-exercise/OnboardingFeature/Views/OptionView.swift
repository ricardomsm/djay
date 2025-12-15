import UIKit

final class OptionView<Id: Hashable>: UIControl {
    private lazy var circle: UIImageView = {
        let image = UIImage(systemName: "circle")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white.withAlphaComponent(Constants.circleAlpha)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var filledCircle: UIImageView = {
        let image = UIImage(
            systemName: "checkmark.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor()
        )

        let imageView = UIImageView(image: image)
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var optionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var option: Option<Id>? {
        didSet { optionLabel.text = option?.label }
    }

    override var isSelected: Bool {
        didSet { animateSelection() }
    }

    var hasSelectedOption: ((Id) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else { return }
        isSelected = !isSelected
        option.map { hasSelectedOption?($0.id) }
    }

    private func setup() {
        clipsToBounds = true
        backgroundColor = .white.withAlphaComponent(Constants.backgroundAlpha)
        layer.cornerRadius = Constants.cornerRadius
        [circle, filledCircle, optionLabel].forEach(addSubview(_:))
        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            circle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingPadding),
            circle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
            filledCircle.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            filledCircle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingPadding),
            filledCircle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
            optionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            optionLabel.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: Constants.labelLeadingPadding),
            optionLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.leadingPadding),
            optionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
        ])
    }

    private func animateSelection() {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self else { return }
            layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.clear.cgColor
            filledCircle.isHidden = !isSelected
            circle.isHidden = isSelected
        }
    }
}

// MARK: - Constants
private enum Constants {
    static let circleAlpha: CGFloat = 0.25
    static let backgroundAlpha: CGFloat = 0.1
    static let fontSize: CGFloat = 17
    static let cornerRadius: CGFloat = 12
    static let verticalPadding: CGFloat = 14
    static let leadingPadding: CGFloat = 18
    static let labelLeadingPadding: CGFloat = 8
    static let animationDuration: TimeInterval = 0.5
}
