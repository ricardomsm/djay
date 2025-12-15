# djay Engineering Task 🎧🎹

This repository contains the solution for the djay engineering task. The goal of this task was to create a 4-step onboarding flow for an iPhone application, with a focus on UI adaptability.

## Implementation Details

The project was implemented using UIKit, and the UI was built programmatically without the use of storyboards. The UI is responsive and works in both landscape and portrait orientations, and on all screen sizes from the iPhone 16e up to the iPhone 17 Pro Max.

### Project Structure

The project is organized into the following main components:

*   `djay-exercise/`: The main application module.
    *   `OnboardingFeature/`: Contains the source code for the onboarding flow.
        *   `Models/`: Contains the data models for the onboarding flow.
        *   `Views/`: Contains the view controllers for the onboarding flow.
    *   `CommonUI/`: Contains reusable UI components.
*   `djay-exercise.xcodeproj/`: The Xcode project file.

I opted for this simplified structure instead of dividing this particular feature into it's own SPM Package or an XCFramework since I didn't see a particular need to given the goal to achieve.

### Data Flow and Architecture

The `OnboardingPageViewController` is the main view controller for the onboarding flow. It manages the different onboarding screens, which are implemented as separate view controllers. The data is passed between the view controllers using closures since it was enough for the current goal.

### UI Adaptability

The UI adaptability was achieved by using Auto Layout and by dynamically changing the layout of the views based on the current size class. The view controllers have separate sets of constraints for regular and compact size classes, and they update the layout of their views in the `traitCollectionDidChange` method given the minimum version is iOS 15.

### Third-Party Libraries

The only third-party library used in this project is `SwiftyGif`, which is used to display the GIF on the "congratulations" screen.

## Potential Improvements

As mentioned above, the data flow and architecture of the application could be improved by using a more structured approach. Additionally, the constraint management in the view controllers is complex and could be simplified by using a more structured approach, such as creating a custom view for each size class or using a third-party library like `SnapKit`.
