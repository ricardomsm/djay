struct OnboardingSteps: Equatable {
    var current: Steps
    let steps: [Steps]
}

extension OnboardingSteps {
    enum Steps: CaseIterable {
        case welcome
        case intro
        case skillLevel
        case congratulations

        var next: Self? {
            switch self {
            case .welcome:
                .intro
            case .intro:
                .skillLevel
            case .skillLevel:
                .congratulations
            case .congratulations:
                nil
            }
        }

        var previous: Self? {
            switch self {
            case .welcome:
                nil
            case .intro:
                .welcome
            case .skillLevel:
                .intro
            case .congratulations:
                .skillLevel
            }
        }
    }
}
