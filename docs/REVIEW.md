# Flyer Package - Full Review

> **Reviewed on:** 2026-04-16
> **Version:** 1.2.0
> **SDK:** Dart ^3.5.4

---

## 1. Overview

Flyer is a Dart CLI tool that accelerates Flutter app development by automating repetitive scaffolding tasks. It generates project infrastructure, features, pages, forms, and manages localization and deep linking.

**Entry Point:** `bin/flyer.dart` using `CommandRunner` from the `args` package.

### Registered Commands

| Command      | Class              | Description                                    |
|--------------|--------------------|------------------------------------------------|
| `init`       | `InitCommand`      | Scaffolds project infrastructure + installs packages |
| `make`       | `MakeCommand`      | Creates features, pages, forms, languages      |
| `fiend`      | `FiendCommand`     | Finds unused assets, packages, files           |
| `run`        | `RunCommand`       | Utility tasks (code formatting)                |
| `watch`      | `WatchCommand`     | Auto-generates missing localization keys       |
| `deeplink`   | `DeeplinkCommand`  | Sets up and tests deep linking (Android/iOS)   |

---

## 2. Architecture

```
lib/
├── commands/          # CLI commands (6 commands)
├── core/              # Utilities, helpers, constants
├── creators.dart      # Central factory for all generation logic
├── functions/         # Standalone utility functions
│   ├── deeplink/      # Deep link setup & testing
│   └── localization/  # Localization analysis & key injection
├── samples/           # Code templates (string generators)
│   ├── extensions/
│   └── utils/
└── app/               # Empty scaffold (bloc, data, models, utils)
```

### Key Design Patterns

- **Factory Pattern:** `Creators` class contains all static methods for generating project components
- **Template Pattern:** Each sample file returns a string with code templates and placeholder interpolation
- **Feature Module Pattern:** Each generated feature is self-contained (feature, page, bloc, state, actions)

---

## 3. Commands Deep Dive

### 3.1 `init` Command

**What it does:**
1. Creates project folder structure (app, theme, config, core, features)
2. Generates splash and home features with full bloc setup
3. Rewrites `main.dart` with app bootstrap code
4. Adds localization files (`.arb`) - defaults to `ar` and `en`
5. Installs 11 packages + dependency overrides
6. Runs `pub get` and `flutter gen-l10n`

**Installed Packages:**
- `app_features`, `api_request`, `equatable`, `hive_flutter`, `get_it`
- `flutter_bloc`, `flutter_easyloading`, `toastification`
- `responsive_framework`, `app_forms`, `requests_inspector`
- **Dependency Override:** `intl`

**Generated Structure:**
```
lib/
├── app/
│   ├── app_feature.dart        # AppFeature with dependencies registration
│   ├── bloc/app_bloc.dart      # App-level Cubit
│   ├── bloc/app_state.dart     # App-level State (Equatable)
│   └── utils/notification_util.dart  # Toast, dialog, bottom sheet helpers
├── config/app_config.dart      # GetIt + AppFeatures.config setup
├── core/
│   ├── app_storage.dart        # Hive-based storage (theme, locale, token)
│   ├── extensions/context_extension.dart  # width, height, loc, theme
│   └── utils/api_util.dart     # API config with requests_inspector
├── theme/
│   ├── app_theme.dart          # Light/dark ThemeData
│   └── app_colors.dart         # Color constants
├── features/
│   ├── splash/                 # Initial splash (3s delay -> home)
│   └── home/                   # Home with language/theme toggle
├── l10n/app_ar.arb             # Arabic localization
├── l10n/app_en.arb             # English localization
└── main.dart                   # Full app bootstrap
```

### 3.2 `make` Command

| Option          | Action                                      |
|-----------------|---------------------------------------------|
| `--feature, -f` | Creates feature folder + feature, page, bloc, state files |
| `--page`        | Adds page to existing feature + updates routes in feature file |
| `--form`        | Creates form using `app_forms` package with specified fields |
| `--lang`        | Adds `.arb` files for specified languages    |
| `--model, -m`   | Generates Dart model from JSON (defined but not implemented in current code) |

**Feature Creation Flow:**
1. Creates `features/{name}/` with `actions/` and `bloc/` subdirectories
2. Generates `{name}_feature.dart` extending `Feature` from `app_features`
3. Generates `{name}_page.dart` (StatelessWidget)
4. Generates `bloc/{name}_bloc.dart` (Cubit) and `bloc/{name}_state.dart` (Equatable)
5. Updates `app_config.dart` to register the new feature

**Page Addition Flow:**
1. Reads the feature file
2. Parses routes list using regex
3. Injects new `GoRoute` entry
4. Adds private getter for route path
5. Adds `push{PageName}()` method
6. Adds import statement

### 3.3 `fiend` Command

| Option             | Function                    |
|--------------------|-----------------------------|
| `--unusedAssets`   | `fiendUnusedAssets()` - Scans assets directory, checks references in Dart files |
| `--unusedPackages` | `fiendUnusedPackages()` - Reads pubspec.yaml, checks import statements |
| `--unusedFiles`    | `findUnusedFiles()` - Scans lib/ for unreferenced `.dart` files |

All three offer interactive deletion with user confirmation.

### 3.4 `run` Command

| Option     | Function         |
|------------|------------------|
| `--format` | `formatCode()` - Uses `DartFormatter` to format all `.dart` files in `lib/` |

### 3.5 `watch` Command

| Option       | Description                        | Default |
|--------------|------------------------------------|---------|
| `--loc`      | Watch for missing localization keys | `false` |
| `--debounce` | Debounce time in seconds           | `2`     |
| `--verbose`  | Show detailed logs                 | `false` |

**Flow:**
1. Watches `lib/` for `.dart` file changes
2. Runs `dart analyze` to find missing `AppLocalizations` getters
3. Extracts missing key names from error output
4. Adds keys to all `.arb` files with language-appropriate defaults
5. Runs `flutter gen-l10n` to regenerate

### 3.6 `deeplink` Command

**Setup Mode** (`--domain` / `--scheme`):
- Extracts project info (Android package, iOS bundle ID, Team ID, SHA256)
- Updates `AndroidManifest.xml` with intent filters
- Creates `assetlinks.json` and `apple-app-site-association`
- Updates iOS `Info.plist`
- Generates `deeplink_handler.dart` utility class (singleton pattern)
- Installs `app_links` package
- Supports `--dry-run` to preview changes

**Test Mode** (`--test`):
- Tests deep links on Android via `adb`
- Shows iOS testing instructions
- Supports `--android` / `--ios` platform filtering

---

## 4. Core Components

### `CreatorUtil` - File Operations
| Method                  | Description                                    |
|-------------------------|------------------------------------------------|
| `createDirectory()`     | Creates directory with logging                 |
| `createFileWithContent()` | Creates file, auto-formats Dart code         |
| `readFileContent()`     | Reads file asynchronously                      |
| `editFileContent()`     | Writes file, auto-formats, creates if not exists |

All file creation uses `DartFormatter` with `latestLanguageVersion` by default.

### `AppHelper` - Name Conversion
| Method          | Description                              |
|-----------------|------------------------------------------|
| `toClassName()` | `snake_case` -> `PascalCase`             |
| `toFileName()` | `PascalCase` -> `snake_case`              |

### `ColorsText` - Terminal Colors
ANSI escape codes for colored output: reset, blue, cyan, green, red, yellow, orange, gray.

### `PackagesName` - Package Lists
Centralized list of packages installed during `init`.

---

## 5. Dependencies

| Package      | Purpose                          |
|-------------|----------------------------------|
| `args`      | CLI argument parsing             |
| `dart_style` | Dart code formatting            |
| `yaml`      | YAML parsing (pubspec)           |
| `http`      | HTTP requests (pub.dev version lookup) |

---

## 6. Issues & Observations

### Fixed Issues

1. ~~**`creatores.dart`** - filename typo~~ -> Renamed to `creators.dart`
2. ~~**`formate_code.dart`** - filename typo~~ -> Renamed to `format_code.dart`
3. ~~**`fined_unused_assets.dart`** - filename typo~~ -> Renamed to `find_unused_assets.dart`
4. ~~**`fined_unused_file.dart`** - filename typo~~ -> Renamed to `find_unused_file.dart`
5. ~~**`fiend_unused_package.dart`** - filename typo~~ -> Renamed to `find_unused_package.dart`
6. ~~**Function names** `fiendUnusedAssets()`, `fiendUnusedPackages()`~~ -> Renamed to `findUnusedAssets()`, `findUnusedPackages()`
7. ~~**Help text typos** "Fiend unused..."~~ -> Fixed to "Find unused..."
8. ~~**Mixed async patterns** in `Creators`~~ -> `init()`, `_createCoreFolder()`, `_createInitFeature()` now properly return `Future<void>` and are awaited
9. ~~**`addPage()` return type** was `void` with `async` body~~ -> Fixed to `Future<void>`
10. ~~**`readFileContent()` returned `'File not exists'` string on error**~~ -> Now throws `FileSystemException`
11. ~~**`install_package.dart` hardcoded `responsive_framework` to `0.2.0`**~~ -> Now uses latest version from pub.dev
12. ~~**`addAction()` in `Creators` duplicated `addForm()` logic**~~ -> Now properly creates action files in `actions/` directory
13. ~~**`fields` help text** in `MakeCommand` said "Add Languages For App"~~ -> Fixed to "Add Fields For Form"
14. ~~**`user_helper.dart`** showed `dart run fly` instead of `flyer`~~ -> Fixed

### Remaining Issues

1. **Model generation (`--model`)** - Defined in `MakeCommand` argParser but no implementation found in `Creators` class.
2. **`createFileWithContent()` silently skips if file exists** - No warning or overwrite option.
3. **`add_action.dart` in `functions/` is fully commented out** - Dead code.
4. **No unit tests** exist for the CLI tool itself.

### Code Quality

- **Consistent pattern usage** across all generators
- **Clean separation** between commands, creators, and templates
- **Good use of colored output** for user feedback
- **Interactive prompts** as fallback when CLI options are missing

### Security

- **No command injection risks** - `Process.run` is used correctly with argument lists
- **File operations are local-only** - No remote code execution
- **HTTP calls to pub.dev** only for version checking

---

## 7. Generated App Architecture

The generated Flutter app follows these patterns:

- **State Management:** `flutter_bloc` (Cubit pattern) with `equatable` states
- **Routing:** `go_router` via `app_features` package
- **DI:** `get_it` for dependency injection
- **Storage:** `hive_flutter` for local persistence
- **API:** `api_request` package with `requests_inspector` for debugging
- **Localization:** Flutter's built-in `flutter_localizations` with `.arb` files
- **Responsive:** `responsive_framework` for adaptive layouts
- **UI Utilities:** `flutter_easyloading` + `toastification` for notifications

---

## 8. Recommendations

### High Priority
1. **Implement or remove model generation** - The `--model` option is advertised but not functional

### Medium Priority
2. **Add unit tests** for core generation logic
3. **Add `--force` flag** to overwrite existing files

### Low Priority
4. **Add `--dry-run` option** to all commands (currently only in deeplink)
5. **Consider adding a `doctor` command** to validate project structure
6. **Remove dead code** in `functions/add_action.dart`
