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
