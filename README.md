# Scanera

Cross-platform mobile application created with Flutter for the Final Semester Project.

### Thesis

Cross-platform mobile application for heterogeneous location data acquisition

#### Abstract
Location data acquisition is becoming crucial in various fields such as transportation, urban planning, and emergency services. However, current location data acquisition methods often rely on specialized devices and software, making it difficult to gather and combine data from different sources. In this thesis, I propose "Scanera" - a cross-platform mobile application for heterogeneous location data acquisition that can be used on both iOS and Android devices. The application allows for the collection of Bluetooth, Wi-Fi, magnetometer, accelerometer, and gyroscope data from the device, as well as storing and processing the collected data.

---

### Table of Contents
- [Requirements](#requirements)
- [Setup](#setup)
- [Builds](#builds)
- [Features](#features)
- [Project structure](#project-structure)
- [Important code objects](#important-code-objects)
- [License](#license)

### Requirements
Flutter SDK version 3.3.10 must be installed on your machine.

Project debugging should be done on a real device.

Some of the functionalities will not work on the emulator.

### Setup

#### To get started with the project, follow these steps:

1. Clone the repository to your local machine
2. Open the project in your preferred development environment (Android Studio or VS Code)
3. Run commands in the terminal in the main directory
```bash
flutter pub get                                                   #install the required dependencies
flutter pub run build_runner build --delete-conflicting-outputs   #auto-generate dependency code files
```
5. Run the project by clicking on the "run" button or by typing `flutter run` in the terminal


### Builds

##### Android apk
- Run `flutter build apk`.
- Once the build is complete, you can find the APK file in the `build/app/outputs/apk/release` directory.

##### iOS ipa
- Run `flutter build ios --release`
- Once the build is complete, you can find the IPA file in the `build/ios/iphoneos` directory.


### Features
- scan for Bluetooth devices data
- scan for Wi-Fi devices data
- scan for sensors data
- combined data scan
- scan configuration usage
- viewing scan results and configurations
- exporting scan results


### Project structure
- `assets`: Contains the static assets for the application such as images and fonts
- `blocs`: Contains Bloc structures 
- `ext`: Contains class extentions
- `inject`: Contains injection structures
- `l10n`: Contains text translations
- `manager`: Contains
- `model`: Contains data models
- `navigation`: Contains routing logic
- `screen`: Contains UI views
- `theme`: Contains theme configuration
- `util`: Contains utilization files
- `widget`: Contains widgets
- `tests`: Contains the test files for the application

### Important code objects
- `ScanBluetoothManager class` - manages bluetooth scanning
- `ScanWifiManager class` - manages wifi scanning
- `ScanSensorsManager class` - manages sensors scanning
- `ScanAllManager class` - manages bluetooth,wifi and sensors scanning
- `FileManager class` - manages file operations


### License
This project is licensed under the BSD-3 Clause License - see the LICENSE.md file for details.
