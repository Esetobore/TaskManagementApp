# Todoey - Task Management App

Todoey is a modern task management application built with Flutter and Firebase, featuring a clean and intuitive user interface for managing daily tasks efficiently.

## Features

### Authentication
- Email/Password authentication
- Secure logout functionality

### Task Management
- Create and manage tasks
- Real-time task status updates
- Task filtering by status:
    - In Progress
    - Completed
    - On Hold
    - Yet to Start (Pending)
- Task search functionality
- Task statistics dashboard with visual representations

### Statistics Dashboard
- Visual representation of task distribution
- Real-time statistics updates
- Categories:
    - In Progress tasks
    - Completed tasks
    - On Hold tasks
    - Pending tasks
- Statistical cards and chart

## Prerequisites

Before you begin, ensure you have the following installed:
- Flutter (latest stable version)
- Dart SDK
- Android Studio / Xcode (for iOS development)
- Firebase CLI
- Git

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/Esetobore/TaskManagementApp.git
cd todoey
```

### 2. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication with Email/Password.
3. Create a Cloud Firestore database
4. Download and add the Firebase configuration files via the official firebase documentation

### 3. Configure Firebase in the App

1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Configure Firebase for your app:
```bash
flutterfire configure --project=your-firebase-project-id
```

### 4. Install Dependencies

Run the following command to install required dependencies:
```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Acknowledgments
- Flutter team for the amazing framework
- Firebase for backend services
