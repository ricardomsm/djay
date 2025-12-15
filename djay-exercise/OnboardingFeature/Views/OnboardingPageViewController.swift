import UIKit

final class OnboardingPageViewController: UIPageViewController {
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = onboardingSteps.steps.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private var onboardingSteps: OnboardingSteps
    private var gradientLayer: CAGradientLayer?
    private var skillLevel: SkillLevel?

    init(
        tabs: OnboardingSteps = .init(current: .welcome, steps: OnboardingSteps.Steps.allCases),
        transitionStyle style: UIPageViewController.TransitionStyle = .scroll,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        self.onboardingSteps = tabs
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let firstPage = OnboardingViewControllerFactory.make(
            from: onboardingSteps.current,
            moveToIntro: { [weak self] in
                guard
                    let self,
                    let nextStep = onboardingSteps.current.next,
                    let nextStepIndex = onboardingSteps.steps.firstIndex(of: nextStep)
                else { return }

                onboardingSteps.current = nextStep
                pageControl.currentPage = nextStepIndex
            },
            moveToNextStep: moveToNextStep
        )

        setViewControllers([firstPage], direction: .forward, animated: false)

        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pageControl.heightAnchor.constraint(equalToConstant: 7)
        ])
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        setupGradient()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard let previousTraitCollection, let gradientLayer else { return }

        switch (previousTraitCollection.verticalSizeClass, traitCollection.verticalSizeClass) {
        case (.compact, .regular), (.regular, .compact):
            gradientLayer.frame = view.frame
            gradientLayer.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 0)

        default:
            break
        }
    }

    private func setupGradient() {
        let colors: [UIColor] = [#colorLiteral(red: 0.006337461527, green: 0.006436535623, blue: 0.009510123171, alpha: 1), #colorLiteral(red: 0.3874682784, green: 0.392734617, blue: 0.5259623528, alpha: 1)]
        gradientLayer = CAGradientLayer.gradientLayer(colors: colors, in: view.frame)
        if let gradientLayer { view.layer.insertSublayer(gradientLayer, at: 0) }
    }

    private func moveToNextStep() {
        guard
            let nextStep = onboardingSteps.current.next,
            let nextStepIndex = onboardingSteps.steps.firstIndex(of: nextStep)
        else { return }

        let nextPage: UIViewController?

        switch nextStep {
        case .intro:
            nextPage = OnboardingViewControllerFactory.make(
                from: nextStep,
                moveToNextStep: { [weak self] in self?.moveToNextStep() }
            )
        case .skillLevel:
            nextPage = OnboardingViewControllerFactory.make(
                from: nextStep,
                moveToNextStep: { [weak self] in self?.moveToNextStep() },
                didSelectSkillLevel: { [weak self] in self?.skillLevel = $0 }
            )

        case .congratulations:
            guard let skillLevel else {
                nextPage = nil
                break
            }

            nextPage = OnboardingViewControllerFactory.make(from: nextStep, moveToNextStep: {}, skillLevel: skillLevel)

        case .welcome:
            nextPage = nil
        }

        guard let nextPage else {
            fatalError("Should not be possible to create a view controller for welcome step at this point or without a skill level")
        }

        onboardingSteps.current = nextStep
        pageControl.currentPage = nextStepIndex
        setViewControllers([nextPage], direction: .forward, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource Delegate
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return nil
    }
}

// MARK: - Child VC factory
@MainActor
enum OnboardingViewControllerFactory {
    static func make(
        from tab: OnboardingSteps.Steps,
        moveToIntro: @escaping () -> Void = {},
        moveToNextStep: @escaping () -> Void,
        didSelectSkillLevel: @escaping (SkillLevel) -> Void = { _ in },
        skillLevel: SkillLevel = .beginner
    ) -> UIViewController {
        switch tab {
        case .welcome, .intro:
            return WelcomeViewController(continueToIntro: moveToIntro, continueToNextStep: moveToNextStep)
        case .skillLevel:
            return SkillLevelViewController(
                continueAction: moveToNextStep,
                didSelectSkillLevel: didSelectSkillLevel
            )
        case .congratulations:
            return CongratsViewController(skillLevel: skillLevel)
        }
    }
}
