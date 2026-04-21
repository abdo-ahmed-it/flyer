## 1.4.0
* **NEW COMMAND**: `flyer ci ios` — Scaffolds a full GitHub Actions + Fastlane
  pipeline that ships your iOS app to TestFlight (macos-26 runner, Xcode 26.1.1,
  iOS 26 SDK for Apple's April 2026 deadline).
  - Auto-detects **Bundle ID** and **Team ID** from `ios/Runner.xcodeproj`
    (falls back to `--bundle-id` / `--team-id` overrides)
  - Generates: `.github/workflows/deploy.yml`, `Fastfile`, `Appfile`, `Matchfile`,
    `ExportOptions.plist`, `Gemfile`, and patches `Podfile` + `.gitignore`
  - `--shorebird` flag: runs `shorebird init` if needed, adds `Pluginfile`,
    generates `release_shorebird` / `patch_shorebird` lanes, and patches
    `AndroidManifest.xml` with the `INTERNET` permission required by Shorebird
  - `--match-git-url` (prompted if omitted) wires the shared Fastlane match
    certificates repo
  - `--dry-run` previews all changes without writing
  - Prints a next-steps checklist (App Store Connect setup, first `match`
    run, and the 7-8 GitHub Secrets to add)

## 1.3.0
* **NEW FEATURE**: Firebase Integration (`--firebase` flag)
  - Installs `firebase_core` and `firebase_messaging`
  - Adds `Firebase.initializeApp()` to `main.dart`
  - Generates `AppNotifications` class for FCM push notifications (permissions, listeners, token management)
  - Runs `flutterfire configure` interactively
  - AppBloc auto-initializes notifications with `initNotification()` and `setFcmToken()`
* **NEW FEATURE**: Onboarding (`--onboarding` flag)
  - Generates onboarding feature with PageView intro screens
  - Dot indicators, skip/next navigation
  - Shown only on first launch via `AppStorage.getShowOnboarding()`
* **NEW FEATURE**: MasterPage with Floating Bottom Navigation Bar
  - Modern floating pill-shape design with animated transitions
  - Bounce animation, haptic feedback, dark mode support
  - `IndexedStack` for preserving tab states
  - `AppBloc` manages tab index with `changeIndex()`
  - `BottomNavData` and `BottomNavItemModel` for easy tab configuration
* **NEW FEATURE**: AppStyles text style system
  - Full text style set (thin, light, regular, medium, semibold, bold) at multiple sizes
  - Bundled Almarai font files auto-copied to `assets/fonts/`
  - Font configuration auto-added to `pubspec.yaml`
* **NEW FEATURE**: Default `account` feature generated alongside `splash` and `home`
* **IMPROVEMENT**: Static access getters on all generated features and blocs
  - `AccountFeature.to.go()`, `AccountBloc.to.emit()`
* **IMPROVEMENT**: Splash navigates to MasterPage (AppFeature) instead of HomeFeature directly
* **FIX**: Renamed files with typos (`creatores.dart` -> `creators.dart`, `formate_code.dart` -> `format_code.dart`, `fined_unused_*` -> `find_unused_*`)
* **FIX**: Fixed async/sync mismatch in `Creators.init()`
* **FIX**: `readFileContent()` now throws `FileSystemException` instead of returning error string
* **FIX**: Removed hardcoded `responsive_framework` version
* **FIX**: Updated `responsive_framework` API to v1.5+ (`ResponsiveBreakpoints`/`Breakpoint`)
* **FIX**: Removed deprecated `enableLog` in favor of `logLevel: ApiLogLevel.info`
* **FIX**: Removed dead action code and unused imports
* **FIX**: Fixed help text typos (`Fiend` -> `Find`)

## 1.2.0
* **NEW FEATURE**: Watch Command - Automatically monitor project files and regenerate code on changes
  - Improves development workflow with automatic code generation
  - Watches for file changes and triggers appropriate actions
* **IMPROVEMENT**: Init Command Enhancements
  - Now automatically adds Arabic (`ar`) and English (`en`) languages by default
  - Automatically installs `request_inspector` package for API debugging
  - Better default configuration for new projects
* **FIX**: Fixed various issues and improved stability
  - Resolved diagnostic warnings
  - Enhanced code quality and formatting

## 1.1.0
* **NEW FEATURE**: Deep Linking - Generate complete deep link system for your Flutter app
  - Auto-generates DeepLinkHandler, DeepLinkRoutes, and DeepLinkConfig
  - Automatically configures Android (AndroidManifest.xml) and iOS (Info.plist)
  - Interactive prompts for scheme and host configuration
  - Full documentation in DEEPLINK_GUIDE.md
* **IMPROVEMENT**: Enhanced CLI output styling across all commands
  - Added colored headers, emojis, and structured output
  - Improved error messages and success confirmations
  - Better user experience with clear visual feedback
* **FIX**: Route generation in `make` command now creates properly formatted routes
  - Fixed comma issues in routes list
  - Added private getters and push functions for each route
  - Improved code formatting for generated route code

## 1.0.0
* Upgrade: dart version && flutter version and dependencies
* Fix : issue when flyer command run

## 0.0.2
* FIX: flutter version

* EDIT: Improved Documentation

## 0.0.1

* TODO: initial release.
