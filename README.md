# LoreScanner

A scanner application for the Lorcana TCG by Ravensburger. This app allows users to scan Lorcana cards using their device's camera, recognize the cards, and manage their collection.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Technical Strategy](#technical-strategy)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Running the App](#running-the-app)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Contributing](#contributing)

## Project Overview

LoreScanner is a mobile application built with Flutter that aims to provide a seamless experience for Lorcana TCG players to identify and manage their card collections. The core functionality revolves around using the device's camera to capture images of cards, performing text recognition to identify the card's name, and then matching it against a database of Lorcana cards.

## Features

- **Card Scanning:** Real-time card scanning using the device camera.
- **Text Recognition:** Utilizes Google ML Kit for accurate text extraction from card images.
- **Card Identification:** Matches recognized text against a comprehensive Lorcana card database.
- **Collection Management:** Allows users to save scanned cards to their digital collection.
- **Light/Dark Mode:** Supports system, light, and dark themes for user preference.

## Technical Strategy: Text-Based Card Recognition with Google ML Kit

- **Goal:** Recognize Lorcana cards in real-time using the camera and display identified cards.
- **Approach:** Leverage Google ML Kit for text recognition to extract card names, which are then compared against a database.
- **Advantages:**
  - Eliminates the need to train a complex image classification model.
  - Utilizes the robustness of ML Kit for text recognition, which is often more reliable than pure image classification for this use case.

---

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (ensure it's added to your PATH)
- An IDE such as [Android Studio](https://developer.android.com/studio) (with Flutter plugin) or [VS Code](https://code.visualstudio.com/) (with Flutter extension).
- A physical device or emulator for testing.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/LoreScanner/lore_scanner.git
    cd lore_scanner
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

## Running the App

1.  Ensure you have a device connected or an emulator running.
2.  Run the app using the Flutter CLI:
    ```bash
    flutter run
    ```
    Alternatively, you can run the app from your IDE (Android Studio or VS Code).

## Project Structure

The project follows a standard Flutter application structure:

```
lore_scanner/
├── android/              # Android specific files
├── assets/               # Static assets like images and fonts
│   └── images/
├── docs/                 # Project documentation files
├── ios/                  # iOS specific files
├── lib/                  # Main Dart code
│   ├── constants.dart
│   ├── main.dart
│   ├── models/           # Data models (Card, Collection, etc.)
│   ├── pages/            # Individual screen/page widgets
│   ├── provider/         # State management providers (ThemeProvider, CardsProvider)
│   ├── screens/          # UI screens
│   ├── service/          # Business logic (API, Database, ML Kit integration)
│   └── widgets/          # Reusable UI components
├── test/                 # Automated tests (not yet implemented in this example)
├── .gitignore
├── analysis_options.yaml # Dart static analysis configuration
├── pubspec.lock
├── pubspec.yaml          # Project dependencies and metadata
└── README.md             # This file
```

Key directories:

-   `lib/`: Contains all the Dart code for the application.
    -   `main.dart`: The entry point of the application.
    -   `models/`: Defines the data structures used in the app.
    -   `pages/` & `screens/`: Contain the UI for different parts of the app.
    -   `provider/`: Manages the application's state using Provider.
    -   `service/`: Houses the logic for interacting with external services (like APIs, ML Kit) and the local database.
    -   `widgets/`: Stores custom reusable widgets.
-   `docs/`: Contains detailed documentation about specific aspects of the project.
-   `assets/`: Stores static files like images.

## Documentation

For more detailed information on specific aspects of the project, please refer to the documents in the `docs/` directory:

-   [App Initialization (`docs/INITIALIZATION.md`)](docs/INITIALIZATION.md)
-   [Theme System (`docs/THEMING.md`)](docs/THEMING.md)
-   (More documents to be added for Card Scanning and Data Persistence)

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes.
4.  Commit your changes (`git commit -m 'Add some feature'`).
5.  Push to the branch (`git push origin feature/your-feature-name`).
6.  Open a Pull Request.

Please ensure your code adheres to the project's coding standards (see `analysis_options.yaml`).
