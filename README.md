# Self-Mess (PG Management)

A comprehensive management application for Paying Guest (PG) facilities and Mess services. This app streamlines student management, fee tracking, notifications, and reporting.

## 🚀 Key Features

- **Dashboard**: Real-time statistics and visual charts (using `fl_chart`).
- **Student Management**: Add, update, and manage student details.
- **Notification System**: Integrated with Firebase Cloud Messaging (FCM) for instant alerts.
- **Reporting**: Export data to **PDF** and **Excel** formats.
- **Internet Connectivity**: Real-time checking using `connectivity_plus`.
- **State Management**: Robust state management using `GetX`.
- **Local Storage**: Reliable storage using `shared_preferences`.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (v3.35.0)
- **Language**: Dart
- **State Management**: GetX
- **Backend/Services**: Firebase (Cloud Messaging, Core)
- **UI Components**: Shimmer, Lottie, Cached Network Image, Flutter SVG
- **Utils**: PDF, Excel, Spreadsheet Decoder, CSV, Intl

## 📦 Recent Upgrades

- **Flutter SDK**: Upgraded to **3.35.0** using FVM.
- **Android Support**: Added **16 KB page size support** for Android 15 (API 35).
- **Target SDK**: Updated to **API 35**.

## 🚦 Getting Started

### Prerequisites

- [FVM (Flutter Version Management)](https://fvm.app/)
- Flutter SDK (managed by FVM)

### Installation

1. Clone the repository.
2. Ensure FVM is installed.
3. Use the required Flutter version:
   ```bash
   fvm use 3.35.0
   ```
4. Install dependencies:
   ```bash
   fvm flutter pub get
   ```

### Running the Project

To run the project on a connected device:
```bash
fvm flutter run
```

### Build Commands

- **Android APK**:
  ```bash
  fvm flutter build apk --release
  ```
- **Android App Bundle (AAB)**:
  ```bash
  fvm flutter build appbundle --release
  ```
- **Web Build**:
  ```bash
  fvm flutter build web --base-href /frontend/
  ```
- **Clean & Build Web**:
  ```bash
  fvm flutter clean && fvm flutter pub get && fvm flutter build web --base-href /frontend/
  ```

## 📝 License

This project is private and intended for specific PG/Mess management use cases.
