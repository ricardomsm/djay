import UIKit

final class OptionView<Id: Hashable>: UIControl {
    private lazy var circle: UIImageView = {
        let image = UIImage(systemName: "circle")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white.withAlphaComponent(0.25)
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
        label.font = .systemFont(ofSize: 17, weight: .regular)
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

    // MARK: - Private
    private func setup() {
        clipsToBounds = true
        backgroundColor = .white.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        [circle, filledCircle, optionLabel].forEach(addSubview(_:))
        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            circle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            circle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            filledCircle.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            filledCircle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            filledCircle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            optionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            optionLabel.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 8),
            optionLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -18),
            optionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
        ])
    }

    private func animateSelection() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self else { return }
            layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.clear.cgColor
            filledCircle.isHidden = !isSelected
            circle.isHidden = isSelected
        }
    }
}
