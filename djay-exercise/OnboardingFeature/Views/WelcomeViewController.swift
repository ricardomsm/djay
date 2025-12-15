import UIKit

final class WelcomeViewController: UIViewController {
    private lazy var appLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "djay"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.text = "Welcome to djay!"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var devicesImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "hero"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var mixMusicLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = "Mix Your Favorite Music"
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var awardImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ada"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var introStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [devicesImageView, mixMusicLabel, awardImageView])
        stack.axis = .vertical
        stack.spacing = 32
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton(
            configuration: .filled(),
            primaryAction: .init(title: "Continue", handler: { [weak self] _ in self?.didTapContinue() })
        )

        button.configuration?.background.backgroundColor = .systemBlue
        button.configuration?.contentInsets = Constants.continueButtonInsets
        button.configuration?.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var continueButtonRegularConstraints: [NSLayoutConstraint] = [
        continueButton.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: Constants.continueButtonHorizontalSpacing
        ),
        continueButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -Constants.continueButtonHorizontalSpacing
        ),
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ]

    private lazy var continueButtonCompactConstraints: [NSLayoutConstraint] = [
        continueButton.widthAnchor.constraint(equalToConstant: Constants.continueButtonCompactWidth),
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ]

    private let upperStackLayoutGuide = UILayoutGuide()

    private lazy var appLogoWelcomeConstraints: [NSLayoutConstraint] = [
        appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        appLogoImageView.centerYAnchor.constraint(equalTo: upperStackLayoutGuide.centerYAnchor),
    ]

    private lazy var appLogoIntroConstraints: [NSLayoutConstraint] = [
        appLogoImageView.topAnchor.constraint(
            greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 16
        ),
        appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        appLogoImageView.bottomAnchor.constraint(equalTo: introStackView.topAnchor, constant:  -37),
    ]

    private lazy var introStackViewConstraints: [NSLayoutConstraint] = [
        introStackView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 32
        ),
        introStackView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -32
        ),
        introStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ]

    private lazy var welcomeLabelBottomConstraint = welcomeLabel.bottomAnchor.constraint(
        equalTo: continueButton.topAnchor,
        constant: -24
    )

    private lazy var welcomeLabelIntroConstraint = welcomeLabel.bottomAnchor.constraint(
        equalTo: continueButton.bottomAnchor
    )

    private lazy var introStackViewHeightConstraint = introStackView.heightAnchor.constraint(equalToConstant: 0)

    private var currentOnboardingStep = OnboardingSteps.Steps.welcome
    private let continueToIntro: () -> Void
    private let continueToNextStep: () -> Void

    // MARK: - Lifecycle
    init(continueToIntro: @escaping () -> Void, continueToNextStep: @escaping () -> Void) {
        self.continueToIntro = continueToIntro
        self.continueToNextStep = continueToNextStep
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
            NSLayoutConstraint.activate(continueButtonRegularConstraints)
        case .compact:
            NSLayoutConstraint.activate(continueButtonCompactConstraints)
        default:
            break
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
        case (.regular, .compact):
            introStackView.axis = .vertical
            NSLayoutConstraint.deactivate(continueButtonCompactConstraints)
            NSLayoutConstraint.activate(continueButtonRegularConstraints)

        case (.compact, .compact), (.compact, .regular):
            introStackView.axis = .horizontal
            NSLayoutConstraint.deactivate(continueButtonRegularConstraints)
            NSLayoutConstraint.activate(continueButtonCompactConstraints)

        default:
            break
        }
    }

    // MARK: - UI Helpers
    private func setupSubviews() {
        [appLogoImageView, welcomeLabel, continueButton, introStackView].forEach(view.addSubview)
        introStackView.isHidden = true
        view.addLayoutGuide(upperStackLayoutGuide)

        let constraints: [NSLayoutConstraint] = [
            continueButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.continueButtonBottomSpacing
            ),

            welcomeLabelBottomConstraint,
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            upperStackLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            upperStackLayoutGuide.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -16),
            introStackViewHeightConstraint
        ]

        NSLayoutConstraint.activate(constraints + appLogoWelcomeConstraints + introStackViewConstraints)
    }

    private func didTapContinue() {

        switch currentOnboardingStep {
        case .welcome:
            currentOnboardingStep = .intro
            continueToIntro()
            setupIntroView()

        case .intro:
            continueToNextStep()

        case .skillLevel, .congratulations:
            break
        }
    }

    private func setupIntroView() {
        introStackView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self else { return }
            NSLayoutConstraint.deactivate(
                [welcomeLabelBottomConstraint] + appLogoWelcomeConstraints + [introStackViewHeightConstraint]
            )
            NSLayoutConstraint.activate([welcomeLabelIntroConstraint] + appLogoIntroConstraints)
            welcomeLabel.alpha = 0
            view.layoutIfNeeded()
        }
    }
}

// MARK: - Constants
private extension WelcomeViewController {
    enum Constants {
        static let continueButtonHorizontalSpacing: CGFloat = 32
        static let continueButtonBottomSpacing: CGFloat = 42
        static let continueButtonInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        static let continueButtonCompactWidth: CGFloat = 240
    }
}
