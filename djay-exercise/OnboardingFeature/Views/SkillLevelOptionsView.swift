import UIKit

final class SkillLevelOptionsView: UIView {
    private lazy var optionsStack: UIStackView = {
        let optionViews = options.map {
            let view = OptionView<SkillLevel>()
            view.option = $0
            view.hasSelectedOption = { [weak self] in self?.hasSelectedOption($0) }
            return view
        }

        let stackView = UIStackView(arrangedSubviews: optionViews)
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var options: [Option<SkillLevel>] = []
    private var hasSelectedOption: ((SkillLevel) -> Void)?

    convenience init(options: [Option<SkillLevel>], hasSelectedOption: @escaping (SkillLevel) -> Void) {
        self.init(frame: .zero)
        self.options = options
        self.hasSelectedOption = hasSelectedOption
        setup()
    }

    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        addSubview(optionsStack)
        NSLayoutConstraint.activate([
            optionsStack.topAnchor.constraint(equalTo: topAnchor),
            optionsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            optionsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }

    private func hasSelectedOption(_ id: SkillLevel) {
        optionsStack.arrangedSubviews.forEach { view in
            guard let optionView = view as? OptionView<SkillLevel>, optionView.option?.id != id else { return }
            optionView.isSelected = false
        }
        hasSelectedOption?(id)
    }
}
