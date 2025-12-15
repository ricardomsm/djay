enum SkillLevel: CaseIterable, Identifiable {
    case beginner, intermediate, advanced

    var id: some Hashable { self }

    var option: Option<SkillLevel> {
        switch self {
        case .beginner:
            Option(id: self, label: "I’m new to DJing")
        case .intermediate:
            Option(id: self, label: "I’ve used DJ apps before")
        case .advanced:
            Option(id: self, label: "I’m a professional DJ")
        }
    }

    var gifAssetName: String {
        switch self {
        case .beginner:
            "dj-cats"
        case .intermediate:
            "kid-disco"
        case .advanced:
            "dj-khaled"
        }
    }

    var congratsTitle: String {
        "It's the final countdown to end this onboarding! Press the done button for a surprise!"
    }

    var congratsMessage: String {
        switch self {
        case .beginner:
            "Ready to drop the bass? (Don't actually drop it, that's expensive.) Let's make some noise!"
        case .intermediate:
            "Welcome back to the digital decks! Let's hope your beat-matching skills are better than your last app's battery life."
        case .advanced:
            "Welcome, maestro! We've got the tools, you've got the talent. Let's make some magic."
        }
    }
}
