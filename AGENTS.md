# Guidelines for AI Agents

Welcome! If you are an AI agent or coding assistant interacting with this repository, please read these guidelines carefully before suggesting or making changes.

## 1. Project Documentation
Before making architectural changes or assumptions about data flow, review the documentation located in the `docs/` directory:
* **`docs/project_overview.md`**: Core features, dependencies, and project structure.
* **`docs/architecture.md`**: Details on state management (`provider`), background isolates (`fetcher.dart`), and the SQLite schema.
* **`docs/setup_guide.md`**: Developer environment setup and API constraints.

## 2. Strict Android Build Constraints (CRITICAL)
This project utilizes a highly specific and modern Android build configuration. **DO NOT** downgrade or arbitrarily modify the following without explicit user permission:
* **Gradle Version**: `9.3.1` (`android/gradle/wrapper/gradle-wrapper.properties`).
* **Android Gradle Plugin (AGP)**: `9.1.0` (`android/settings.gradle`).
* **Java Version**: Requires `Java 17`. (Warning: Java 25+ causes the AGP daemon and `AndroidLocationsBuildService` to crash on this machine).
* **Built-in Kotlin**: This project uses AGP 9.0's Built-in Kotlin feature. 
  * Do **NOT** add the `kotlin-android` or `org.jetbrains.kotlin.android` plugin.
  * Do **NOT** add a `kotlinOptions {}` block in `android/app/build.gradle`.
  * `android.builtInKotlin=true` must remain in `android/gradle.properties`.

## 3. Architecture & Code Patterns
* **Threading**: Do not perform heavy synchronous networking or HTML parsing on the main thread. The app delegates price fetching and parsing to a background Isolate (`lib/services/fetcher.dart`). Use `SendPort`/`ReceivePort` to stream `FetchedMessage` updates to the UI.
* **Web Scraping**: The app parses live gold prices from `gold.tanaka.co.jp`. If gold prices fail to load, verify that the website's DOM structure (`#metal_price tr.gold`) has not changed.
* **State Management**: Use `ChangeNotifierProvider` (`AppState`) to expose data to the widget tree.

## 4. Version Control
* `ios/Flutter/ephemeral/` and `android/build/` are explicitly ignored in `.gitignore`. Do not attempt to track files in these directories.

## 5. Testing & Verification Protocol
Before completing any task or code modification, verify that:
1. **Static Analysis Passes**: Run `flutter analyze` to ensure zero errors or warnings across the project.
2. **Headless Tests Pass**: Run `flutter test` to ensure all pure Dart unit and parser tests pass.
3. **No Heavy/Emulator Dependencies**: All tests in `test/` must remain fast, headless, and independent of running emulators or external live network services (use offline fixtures for HTML/JSON).

