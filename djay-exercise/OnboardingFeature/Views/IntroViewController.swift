import UIKit

final class IntroViewController: UIViewController {
    private lazy var appLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "djay"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton(
            configuration: .filled(),
            primaryAction: .init(title: "Continue", handler: { [weak self] _ in self?.continueAction()  })
        )

        button.configuration?.background.backgroundColor = .systemBlue
        button.configuration?.contentInsets = Constants.continueButtonInsets
        button.configuration?.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.configuration?.background.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var continueButtonCompactConstraints: [NSLayoutConstraint] = [
        continueButton.widthAnchor.constraint(equalToConstant: Constants.continueButtonCompactWidth),
        continueButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
        continueButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32),
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ]

    private lazy var continueButtonConstraints: [NSLayoutConstraint] = [
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
    ]

    private let continueAction: () -> Void

    // MARK: - Lifecycle
    init(continueAction: @escaping () -> Void) {
        self.continueAction = continueAction
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
            introStackView.axis = .vertical
            NSLayoutConstraint.activate(continueButtonConstraints)

        case .compact:
            introStackView.axis = .horizontal
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
            NSLayoutConstraint.activate(continueButtonConstraints)

        case (.compact, .compact):
            introStackView.axis = .horizontal
            NSLayoutConstraint.deactivate(continueButtonConstraints)
            NSLayoutConstraint.activate(continueButtonCompactConstraints)

        default:
            break
        }
    }

    // MARK: - UI Helpers
    private func setupSubviews() {
        view.backgroundColor = .clear
        [appLogoImageView, introStackView, continueButton].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            appLogoImageView.topAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogoImageView.bottomAnchor.constraint(equalTo: introStackView.topAnchor, constant:  -37),

            introStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            introStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32),
            introStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -42)
        ])
    }
}

// MARK: - Constants
private extension IntroViewController {
    enum Constants {
        static let continueButtonHorizontalSpacing: CGFloat = 32
        static let continueButtonInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        static let continueButtonCompactWidth: CGFloat = 240
    }
}
