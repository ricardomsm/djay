import UIKit

final class SkillLevelViewController: UIViewController {
    private lazy var djEmojiView: UIImageView = {
        let imageView = UIImageView.init(image: .init(named: "smiley-dj"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.text = "Welcome DJ"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.subtitleFontSize, weight: .regular)
        label.text = "What's your DJ skill level?"
        label.textColor = .white.withAlphaComponent(Constants.subtitleAlpha)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var skillLevelOptionsView: SkillLevelOptionsView = {
        let optionsView = SkillLevelOptionsView(
            options: skillLevels.map(\.option),
            hasSelectedOption: { [weak self] in self?.hasSelectedSkillLevel($0) }
        )
        optionsView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        return optionsView
    }()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [djEmojiView, titleLabel, subtitleLabel, skillLevelOptionsView])
        stack.axis = .vertical
        stack.setCustomSpacing(Constants.emojiBottomSpacing, after: djEmojiView)
        stack.setCustomSpacing(Constants.titleBottomSpacing, after: titleLabel)
        stack.setCustomSpacing(Constants.subtitleBottomSpacing, after: subtitleLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var letsGoButton: UIButton = {
        let button = UIButton(
            configuration: .filled(),
            primaryAction: .init(title: "Let's go", handler: { [weak self] _ in self?.continueAction()  })
        )

        button.configuration?.background.backgroundColor = .systemBlue
        button.configuration?.contentInsets = Constants.letsGoButtonInsets
        button.configuration?.attributedTitle?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .semibold)
        button.configuration?.background.cornerRadius = Constants.cornerRadius
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var regularLayoutGuide: UILayoutGuide = { UILayoutGuide() }()
    private lazy var compactLayoutGuide: UILayoutGuide = { UILayoutGuide() }()

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        regularLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        regularLayoutGuide.bottomAnchor.constraint(equalTo: letsGoButton.topAnchor, constant: Constants.regularBottomPadding),
        regularLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        contentStackView.centerYAnchor.constraint(equalTo: regularLayoutGuide.centerYAnchor),
        contentStackView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: Constants.horizontalRegularPadding
        ),
        contentStackView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -Constants.horizontalRegularPadding
        ),

        letsGoButton.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: Constants.horizontalRegularPadding
        ),
        letsGoButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -Constants.horizontalRegularPadding
        ),
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        compactLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        compactLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

        skillLevelOptionsView.leadingAnchor.constraint(
            equalTo: compactLayoutGuide.centerXAnchor,
            constant: Constants.horizontalCompactPadding
        ),
        skillLevelOptionsView.trailingAnchor.constraint(
            equalTo: compactLayoutGuide.trailingAnchor,
            constant: -Constants.horizontalCompactPadding
        ),
        skillLevelOptionsView.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor),
        skillLevelOptionsView.bottomAnchor.constraint(
            lessThanOrEqualTo: letsGoButton.topAnchor,
            constant: -Constants.horizontalCompactPadding
        ),

        contentStackView.leadingAnchor.constraint(
            greaterThanOrEqualTo: compactLayoutGuide.leadingAnchor,
            constant: Constants.horizontalCompactPadding
        ),
        contentStackView.trailingAnchor.constraint(
            lessThanOrEqualTo: compactLayoutGuide.centerXAnchor,
            constant: -Constants.horizontalCompactPadding
        ),
        contentStackView.centerYAnchor.constraint(equalTo: skillLevelOptionsView.centerYAnchor),
        contentStackView.bottomAnchor.constraint(equalTo: skillLevelOptionsView.bottomAnchor),

        letsGoButton.widthAnchor.constraint(equalToConstant: Constants.letsGoButtonCompactWidth),
        letsGoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ]

    private let skillLevels = SkillLevel.allCases
    private let continueAction: () -> Void
    private let didSelectSkillLevel: (SkillLevel) -> Void

    // MARK: - Lifecycle
    init(continueAction: @escaping () -> Void, didSelectSkillLevel: @escaping (SkillLevel) -> Void) {
        self.continueAction = continueAction
        self.didSelectSkillLevel = didSelectSkillLevel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        switch traitCollection.verticalSizeClass {
        case .regular:
            NSLayoutConstraint.activate(regularConstraints)

        case .compact:
            contentStackView.removeArrangedSubview(skillLevelOptionsView)
            skillLevelOptionsView.removeFromSuperview()
            view.addSubview(skillLevelOptionsView)
            NSLayoutConstraint.activate(compactConstraints)

        default:
            break
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
        case (.regular, .compact):
            NSLayoutConstraint.deactivate(compactConstraints)
            contentStackView.addArrangedSubview(skillLevelOptionsView)
            NSLayoutConstraint.activate(regularConstraints)

        case (.compact, .compact), (.compact, .regular):
            NSLayoutConstraint.deactivate(regularConstraints)
            contentStackView.removeArrangedSubview(skillLevelOptionsView)
            skillLevelOptionsView.removeFromSuperview()
            view.addSubview(skillLevelOptionsView)
            NSLayoutConstraint.activate(compactConstraints)

        default:
            break
        }
    }

    private func setupSubviews() {
        view.backgroundColor = .clear
        view.addSubview(contentStackView)
        view.addSubview(letsGoButton)
        view.addLayoutGuide(regularLayoutGuide)
        view.addLayoutGuide(compactLayoutGuide)

        NSLayoutConstraint.activate([
            letsGoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonBottomPadding)
        ])
    }

    private func hasSelectedSkillLevel(_ skillLevel: SkillLevel) {
        letsGoButton.isEnabled = true
        didSelectSkillLevel(skillLevel)
    }
}

// MARK: - Constants
private extension SkillLevelViewController {
    enum Constants {
        static let titleFontSize: CGFloat = 34
        static let subtitleFontSize: CGFloat = 22
        static let buttonFontSize: CGFloat = 17
        static let subtitleAlpha: CGFloat = 0.6
        static let emojiBottomSpacing: CGFloat = 40
        static let titleBottomSpacing: CGFloat = 8
        static let subtitleBottomSpacing: CGFloat = 40
        static let cornerRadius: CGFloat = 12
        static let regularBottomPadding: CGFloat = -16
        static let buttonBottomPadding: CGFloat = -42
        static let letsGoButtonInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        static let letsGoButtonCompactWidth: CGFloat = 240
        static let horizontalCompactPadding: CGFloat = 16
        static let horizontalRegularPadding: CGFloat = 16
    }
}
