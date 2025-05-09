# Flutter Todo App

A feature-rich todo application built with Flutter, featuring task management with categories, priorities, and more. This modern, intuitive app helps you stay organized with a beautiful Material 3 design and powerful features.

## ✨ Features

### 📝 Task Management
- Create, edit, and delete tasks with rich details
- Set task priorities (Low, Medium, High)
- Add and manage due dates with notifications
- Attach images from camera or gallery
- Mark tasks as complete with visual feedback
- Drag-and-drop reordering with haptic feedback
- Rich text descriptions
- Task search and filtering

### 📁 Categories
- Create and manage custom categories
- Customize with colors and icons
- Filter tasks by categories
- Category-based statistics
- Bulk task management within categories

### 🎨 UI/UX
- Material 3 design with dynamic theming
- Dark/Light theme support with system integration
- Responsive layout for all screen sizes
- Bottom navigation for easy access
- Smooth animations and transitions
- Haptic feedback for interactions
- Pull-to-refresh functionality
- Gesture-based actions

### 💾 Data Management
- Offline-first architecture
- Local storage using Hive database
- Automatic state management
- Data backup and restore
- Error handling with user feedback
- Optimistic updates

## 🏗 Architecture & Design

### State Management
- Provider pattern for efficient state management
- MVVM (Model-View-ViewModel) architecture
- Separate providers for different concerns:
  - TodoProvider: Manages todo items state and operations
  - CategoryProvider: Handles category management
  - ThemeProvider: Controls app theme state
  - StorageProvider: Manages data persistence

### Data Flow
```
UI (Widgets) ←→ Providers ←→ Services ←→ Local Storage
```

### Design Decisions
1. **Provider Pattern**
   - Lightweight and efficient state management
   - Official Flutter recommendation
   - Easy testing and maintenance
   - Efficient widget rebuilds

2. **Hive Storage**
   - Fast, lightweight NoSQL database
   - Native Dart implementation
   - Complex object support
   - Async operations
   - Type-safe data storage

3. **Modular Architecture**
   - Feature-based organization
   - Reusable components
   - Clear separation of concerns
   - Easy to extend and maintain

4. **Error Handling**
   - Comprehensive error states
   - Optimistic updates with rollback
   - User-friendly error messages
   - Graceful degradation

## 📦 Dependencies

### Core
- **flutter_sdk: ">=3.0.0 <4.0.0"**
- **dart_sdk: ">=3.0.0 <4.0.0"**

### State Management
- **provider: ^6.0.0**
  - Official Flutter recommendation
  - Efficient state management
  - Easy integration

### Storage
- **hive_flutter: ^1.1.0**
  - High-performance NoSQL database
  - Native Dart implementation
  - Complex object support

### UI Components
- **flutter_slidable: ^3.0.0**
  - Swipe actions
  - Customizable animations
  - Gesture handling

### Utilities
- **image_picker: ^1.0.0**
  - Media selection
  - Camera integration
  - Permission handling

- **uuid: ^4.0.0**
  - Unique identifiers
  - RFC4122 compliance
  - Secure generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Git

#### For iOS Development
- macOS
- Xcode (latest version)
- CocoaPods
- iOS Simulator or physical device

#### For Android Development
- Android Studio
- Android SDK
- Android Emulator or physical device

### Installation

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

### Development Setup
1. Enable Flutter support in your IDE
2. Install recommended extensions
3. Configure code formatting:
   ```bash
   flutter format .
   ```
4. Run tests:
   ```bash
   flutter test
   ```

## 📁 Project Structure

```
lib/
├── models/         # Data models and entities
│   ├── todo.dart
│   └── category.dart
├── providers/      # State management
│   ├── todo_provider.dart
│   └── theme_provider.dart
├── screens/        # App screens and pages
│   ├── home/
│   ├── categories/
│   └── settings/
├── services/       # Business logic and data handling
│   ├── storage/
│   └── utils/
├── widgets/        # Reusable UI components
│   ├── todo_card.dart
│   └── category_tile.dart
└── main.dart       # App entry point
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📧 Contact

For support or queries, please open an issue in the repository.

---
Made with ❤️ using Flutter

