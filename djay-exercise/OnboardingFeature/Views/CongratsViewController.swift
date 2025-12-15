import SwiftyGif
import UIKit

final class CongratsViewController: UIViewController {
    private lazy var congratsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.text = skillLevel.congratsTitle
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var congratsMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.messageFontSize, weight: .regular)
        label.text = skillLevel.congratsMessage
        label.textColor = .white.withAlphaComponent(Constants.messageAlpha)
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var messageStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [congratsTitleLabel, gifImageView, congratsMessageLabel])
        stack.axis = .vertical
        stack.spacing = Constants.stackViewSpacing
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var gifImageView: UIImageView = {
        do {
            let gif = try UIImage(gifName: skillLevel.gifAssetName)
            let imageView = UIImageView(gifImage: gif, loopCount: Constants.gifLoopCount)
            imageView.contentMode = .scaleAspectFit
            imageView.alpha = 0
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        } catch {
            print("🔥 Unable to initialize gif data!")
            return UIImageView()
        }
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(
            configuration: .filled(),
            primaryAction: .init(title: "Done", handler: { [weak self] _ in self?.animateGifView() })
        )

        button.configuration?.background.backgroundColor = .systemBlue
        button.configuration?.contentInsets = Constants.doneButtonInsets
        button.configuration?.attributedTitle?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .semibold)
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var regularMessageConstraints: [NSLayoutConstraint] = [
        messageStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.horizontalPadding),
        messageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
        messageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
        messageStackView.bottomAnchor.constraint(lessThanOrEqualTo: doneButton.topAnchor, constant: -Constants.horizontalPadding),
    ]

    private lazy var compactMessageConstraints: [NSLayoutConstraint] = [
        messageStackView.leadingAnchor.constraint(
            greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: Constants.horizontalPadding
        ),
        messageStackView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Constants.horizontalPadding),
        messageStackView.centerYAnchor.constraint(equalTo: gifImageView.centerYAnchor),
        messageStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: Constants.topPadding)
    ]

    private lazy var compactGifConstraints: [NSLayoutConstraint] = [
        gifImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topPadding),
        gifImageView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Constants.horizontalPadding),
        gifImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalPadding),
        gifImageView.bottomAnchor.constraint(lessThanOrEqualTo: doneButton.topAnchor, constant: Constants.bottomPadding)
    ]

    private lazy var doneButtonRegularConstraints: [NSLayoutConstraint] = [
        doneButton.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: Constants.doneButtonHorizontalSpacing
        ),
        doneButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -Constants.doneButtonHorizontalSpacing
        )
    ]

    private lazy var doneButtonCompactConstraints: [NSLayoutConstraint] = [
        doneButton.widthAnchor.constraint(equalToConstant: Constants.doneButtonCompactWidth),
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ]

    private let skillLevel: SkillLevel

    init(skillLevel: SkillLevel) {
        self.skillLevel = skillLevel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(messageStackView)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.bottomPadding),
        ])
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        switch traitCollection.verticalSizeClass {
        case .regular:
            NSLayoutConstraint.activate(doneButtonRegularConstraints + regularMessageConstraints)
        case .compact:
            messageStackView.removeArrangedSubview(gifImageView)
            gifImageView.removeFromSuperview()
            view.addSubview(gifImageView)
            NSLayoutConstraint.activate(
                doneButtonCompactConstraints + compactMessageConstraints + compactGifConstraints
            )
        default:
            break
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
        case (.regular, .compact):
            NSLayoutConstraint.deactivate(
                doneButtonCompactConstraints + compactMessageConstraints + compactGifConstraints
            )
            gifImageView.removeFromSuperview()
            messageStackView.insertArrangedSubview(gifImageView, at: 1)
            NSLayoutConstraint.activate(doneButtonRegularConstraints + regularMessageConstraints)

        case (.compact, .compact), (.compact, .regular):
            NSLayoutConstraint.deactivate(doneButtonRegularConstraints + regularMessageConstraints)
            messageStackView.removeArrangedSubview(gifImageView)
            gifImageView.removeFromSuperview()
            view.addSubview(gifImageView)
            NSLayoutConstraint.activate(
                doneButtonCompactConstraints + compactMessageConstraints + compactGifConstraints
            )

        default:
            break
        }
    }

    private func animateGifView() {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .transitionCrossDissolve) { [weak self] in self?.gifImageView.alpha = 1 }
    }
}

// MARK: - Constants
private extension CongratsViewController {
    enum Constants {
        static let titleFontSize: CGFloat = 26
        static let messageFontSize: CGFloat = 22
        static let buttonFontSize: CGFloat = 17
        static let messageAlpha: CGFloat = 0.6
        static let stackViewSpacing: CGFloat = 16
        static let gifLoopCount = 30
        static let cornerRadius: CGFloat = 12
        static let horizontalPadding: CGFloat = 32
        static let topPadding: CGFloat = 16
        static let bottomPadding: CGFloat = -42
        static let animationDuration: TimeInterval = 1
        static let doneButtonHorizontalSpacing: CGFloat = 32
        static let doneButtonBottomSpacing: CGFloat = 42
        static let doneButtonInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        static let doneButtonCompactWidth: CGFloat = 240
    }
}
