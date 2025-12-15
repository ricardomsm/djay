import SwiftyGif
import UIKit

final class CongratsViewController: UIViewController {
    private lazy var congratsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
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
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.text = skillLevel.congratsMessage
        label.textColor = .white.withAlphaComponent(0.6)
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var messageStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [congratsTitleLabel, gifImageView, congratsMessageLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var gifImageView: UIImageView = {
        do {
            let gif = try UIImage(gifName: skillLevel.gifAssetName)
            let imageView = UIImageView(gifImage: gif, loopCount: 30)
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
        button.configuration?.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var regularMessageConstraints: [NSLayoutConstraint] = [
        messageStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        messageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
        messageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        messageStackView.bottomAnchor.constraint(lessThanOrEqualTo: doneButton.topAnchor, constant: -32),
    ]

    private lazy var compactMessageConstraints: [NSLayoutConstraint] = [
        messageStackView.leadingAnchor.constraint(
            greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 32
        ),
        messageStackView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -32),
        messageStackView.centerYAnchor.constraint(equalTo: gifImageView.centerYAnchor),
        messageStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 16)
    ]

    private lazy var compactGifConstraints: [NSLayoutConstraint] = [
        gifImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
        gifImageView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 32),
        gifImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
        gifImageView.bottomAnchor.constraint(lessThanOrEqualTo: doneButton.topAnchor, constant: -42)
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
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -42),
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
        UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve) { [weak self] in self?.gifImageView.alpha = 1 }
    }
}

// MARK: - Constants
private extension CongratsViewController {
    enum Constants {
        static let doneButtonHorizontalSpacing: CGFloat = 32
        static let doneButtonBottomSpacing: CGFloat = 42
        static let doneButtonInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        static let doneButtonCompactWidth: CGFloat = 240
    }
}
