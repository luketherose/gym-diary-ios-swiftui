# Gym Diary iOS

A modern and intuitive iOS app to manage your workouts and track your gym progress.

## 🏋️‍♂️ Features

### Workout Management
- **Training Sections**: Organize your workouts in logical sections (e.g., Push/Pull/Legs, Upper Body, Cardio)
- **Custom Workouts**: Create and manage workouts with multiple exercises
- **Drag & Drop**: Easily move workouts between sections
- **Exercise Categories**: Support for different types of exercises (barbell, dumbbell, bodyweight, machine, etc.)

### Exercise Tracking
- **Sets and Reps**: Record sets, repetitions, and weights for each exercise
- **Exercise Variants**: Support for different variants (incline, decline, wide grip, etc.)
- **Workout History**: Keep track of when you last performed a workout
- **Personal Notes**: Add notes for each exercise

### Profile and Settings
- **Personal Information**: Manage your personal data and profile photo
- **Training Settings**: Configure default rest times
- **Units of Measurement**: Choose between kg and lbs
- **Theme**: Support for light and dark themes
- **Notifications**: Configure notifications for workout timers

### Design System
- **Modern UI**: Clean and intuitive interface with SwiftUI
- **Gradients and Colors**: Complete design system with color palette and gradients
- **Reusable Components**: Modular and consistent component system
- **Responsive**: Optimized for different iOS screen sizes

## 🚀 Technologies

- **SwiftUI**: Apple's modern UI framework
- **Swift 5**: Native programming language
- **iOS 18.5+**: Support for the latest iOS versions
- **Xcode 16**: Developed with the latest Xcode version
- **Firebase**: Integration prepared for authentication and database (currently commented out)

## 📱 Requirements

- iOS 18.5 or higher
- Xcode 16 or higher
- Swift 5.0+

## 🛠️ Installation

### Prerequisites
1. Make sure you have Xcode 16 installed
2. Clone the repository

### Project Setup
1. Open the `gym-diary-ios.xcodeproj` file in Xcode
2. Select the `gym-diary-ios` target
3. Choose an iOS simulator or physical device
4. Press ⌘+R to build and run the app

### Repository Cloning
```bash
git clone https://github.com/luketherose/gym-diary-ios-swiftui.git
cd gym-diary-ios
open gym-diary-ios.xcodeproj
```

## 🏗️ Project Structure

```
gym-diary-ios/
├── gym-diary-ios/
│   ├── ContentView.swift          # Main view with TabView
│   ├── PersonalInfoViews.swift    # User profile views
│   ├── DesignSystem.swift         # Design system and components
│   ├── Models.swift              # Data models
│   ├── FirebaseManager.swift     # Firebase management (currently commented)
│   └── Assets.xcassets/         # Graphic assets
├── gym-diary-ios.xcodeproj/     # Xcode project
├── .gitignore                   # Git ignore file
└── README.md                    # This file
```

## 🎯 Usage

### Creating a New Workout
1. Go to the "Workout" tab
2. Tap the "+" button in the top right
3. Enter the workout name
4. Select the destination section
5. Tap "Create"

### Creating a New Section
1. Go to the "Workout" tab
2. Tap the folder with "+" button in the top left
3. Enter the section name
4. Tap "Create"

### Managing Profile
1. Go to the "Profile" tab
2. Tap on the account section to edit personal information
3. Configure training settings
4. Customize notifications and theme

## 🔧 Firebase Configuration (Optional)

To enable Firebase:

1. Add your `GoogleService-Info.plist` to the project folder
2. Uncomment Firebase imports in `FirebaseManager.swift`
3. Uncomment Firebase configuration in `gym_diary_iosApp.swift`
4. Add Firebase dependencies to the project

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## 👨‍💻 Author

**Luca La Rosa**
- GitHub: [@luketherose](https://github.com/luketherose)

## 🙏 Acknowledgments

- Apple for SwiftUI and iOS technologies
- The Swift community for inspiration and support
- All contributors who helped with this project

---

⭐ If you like this project, consider giving it a star on GitHub!
