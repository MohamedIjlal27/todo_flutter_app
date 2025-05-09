# Flutter Todo App

A feature-rich todo application built with Flutter, featuring task management with categories, priorities, and more.

## Features

- ✅ Task Management
  - Create, edit, and delete tasks
  - Set priorities (Low, Medium, High)
  - Add due dates
  - Attach images from camera or gallery
  - Mark tasks as complete
  - Drag-and-drop reordering

- 📁 Categories
  - Create custom categories with colors and icons
  - Organize tasks by categories
  - Edit and manage categories

- 🎨 UI/UX
  - Material 3 design
  - Dark/Light theme support
  - Bottom navigation
  - Responsive layout
  - Smooth animations

- 💾 Data Persistence
  - Offline support
  - Local storage using Hive
  - Automatic state management

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- iOS development setup (for iOS)
  - Xcode (latest version)
  - CocoaPods
- Android development setup (for Android)
  - Android Studio
  - Android SDK

## Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/         # Data models
├── providers/      # State management
├── screens/        # App screens
├── services/       # Business logic
└── widgets/        # Reusable widgets
```

## Dependencies

- provider: ^6.0.0 (State management)
- hive_flutter: ^1.1.0 (Local storage)
- flutter_slidable: ^3.0.0 (Swipe actions)
- image_picker: ^1.0.0 (Image selection)
- uuid: ^4.0.0 (Unique IDs)

