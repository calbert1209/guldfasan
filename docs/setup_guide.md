# Developer Setup & Troubleshooting Guide

## Important Build Configurations

> [!WARNING]
> **DO NOT DOWNGRADE GRADLE OR JAVA VERSIONS**
> This project has been explicitly migrated to support modern Android build requirements. Reverting these will cause the build to fail.

### Android Toolchain Requirements
* **Java Version**: `Java 17` (Strict requirement. Java 25+ will cause the build daemon to crash with `AndroidLocationsBuildService` and `AndroidDirectoryCreator` errors).
* **Gradle Version**: `9.3.1` (Configured in `android/gradle/wrapper/gradle-wrapper.properties`).
* **Android Gradle Plugin (AGP)**: `9.1.0` (Configured in `android/settings.gradle`).

### Kotlin Configuration (Built-in Kotlin)
> [!IMPORTANT]
> The project utilizes AGP 9.0's "Built-in Kotlin" support.
* **`android/gradle.properties`**: Must contain `android.builtInKotlin=true`.
* **`android/app/build.gradle`**: Must **NOT** apply the `kotlin-android` plugin, and must **NOT** contain a `kotlinOptions { jvmTarget = ... }` block, as these are deprecated in AGP 9.0 and will break the build.
* **`android/settings.gradle`**: Must **NOT** contain the `org.jetbrains.kotlin.android` plugin in the plugins block.

## How to Run
1. Ensure `JAVA_HOME` points to a valid Java 17 installation (e.g. `JBR 17` bundled with Android Studio). If using the CLI, you can set it via:
   `flutter config --jdk-dir=/path/to/java17/home`
2. Run `flutter pub get` to fetch dependencies.
3. Run `flutter build apk --debug` to test the Android compilation.
4. Run `flutter run` on an emulator or physical device.

## Known Limitations / External Services
* **CoinGecko API**: Free tier relies on IP-based rate limiting. If the app stops updating crypto prices, the fetcher might be returning a `429 Too Many Requests`.
* **Gold Scraping**: The app scrapes `gold.tanaka.co.jp`. If the DOM structure of that website changes (specifically `#metal_price tr.gold`), the `_parseGoldPrices` method in `lib/services/fetcher.dart` will break and throw a `StateError`.