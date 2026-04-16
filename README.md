# flyer

A powerful CLI package to speed up Flutter app development by automating repetitive tasks like
creating features, pages, forms, and reformatting code and more. Additionally, it initializes
your Flutter project's infrastructure and installs essential packages.

With `flyer`, you can streamline your development process, reduce boilerplate code, and focus
on building your app's core features.

---

## Features

- **Project Initialization**: Set up the infrastructure of your Flutter project and install
  essential packages with Arabic and English localization by default.
- **Feature Generation**: Generate fully-structured Flutter features.
- **Language Support**: Add multiple languages to your app with ease.
- **Page Generation**: Add pages to specific features.
- **Form Generation**: Generate forms with custom fields.
- **Deep Linking**: Setup and test deep linking with automatic Android/iOS configuration.
- **Watch Mode**: Automatically monitor localization keys and add missing ones.
- **Code Formatting**: Reformat your code for consistency.
- **Unused Resources Finder**: Identify and optionally delete unused assets, packages, and files.

---

## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dev_dependencies:
  flyer: <latest version>
```

```bash
dart pub get
```

OR Run the following command to install:

```bash
dart pub add dev:flyer
```

---

## Usage

### Init Command

The `init` command sets up the basic infrastructure for your Flutter project and installs essential
packages.

```bash
flyer init [OPTIONS]
```

#### Available Options

| Option       | Description                          | Example Usage     |
|--------------|--------------------------------------|-------------------|
| `--lang`     | Add languages during initialization (defaults to `en,ar`). | `--lang=en,ar,fr` |
| `--firebase` | Setup Firebase (installs `firebase_core` and runs `flutterfire configure`). | `--firebase` |

#### Examples

```bash
flyer init --lang=en,ar,de
```

With Firebase:

```bash
flyer init --firebase
```

This command:

- Sets up the basic infrastructure for your Flutter project.
- Installs essential packages (`app_features`, `api_request`, `equatable`, `hive_flutter`, `get_it`, `flutter_bloc`, `flutter_easyloading`, `toastification`, `responsive_framework`, `app_forms`, `requests_inspector`).
- **Automatically adds Arabic (`ar`) and English (`en`) languages by default**.
- **Automatically installs `requests_inspector` package for API debugging**.
- Adds any additional languages specified with `--lang` option.
- Displays Messages, Dialogs, and BottomSheet without context.
- Handles app responsiveness using `responsive_framework` package.
- Initializes API configuration using `api_request` package.
- Manages Routes using `go_router` package (via `app_features`).
- **With `--firebase`**: Installs `firebase_core`, adds `Firebase.initializeApp()` to `main.dart`, and runs `flutterfire configure` interactively.

---

### Make Command

The `make` command allows you to create features, pages, forms, and manage languages for
your Flutter project.

```bash
flyer make [OPTIONS]
```

#### Available Options

| Option          | Description                             | Example Usage                                          |
|-----------------|-----------------------------------------|--------------------------------------------------------|
| `--feature, -f` | Create a new feature.                   | `--feature=myFeature`                                  |
| `--lang`        | Add multiple languages to the app.      | `--lang=en,ar`                                         |
| `--page`        | Create a page within a feature.         | `--page=login --feature=account`                       |
| `--form`        | Create a form with fields in a feature. | `--form=login --feature=account --fields=email,password` |

### Examples

#### Create a New Feature

```bash
flyer make --feature=account
```

This creates:
```
lib/features/account/
  account_feature.dart
  account_page.dart
  bloc/account_bloc.dart
  bloc/account_state.dart
  actions/
```

Each generated feature includes quick access getters:

```dart
// Access feature anywhere
AccountFeature.to.go();
AccountFeature.to.push();

// Access bloc anywhere
AccountBloc.to.login(data);
```

#### Add Multiple Languages

```bash
flyer make --lang=en,fr,es
```

#### Generate a Page

```bash
flyer make --page=login --feature=account
```

This adds a new page to the `account` feature, updates the feature's routes, and adds a `pushLogin()` navigation method.

#### Generate a Form

```bash
flyer make --form=login --feature=account --fields=email,password
```

---

### Run Utility Tasks

The `run` command provides utility tasks like reformatting your project's code.

```bash
flyer run [OPTIONS]
```

#### Available Options

| Option     | Description                  | Example Usage   |
|------------|------------------------------|-----------------|
| `--format` | Reformat the project's code. | `--format=.`    |

#### Example

To format your project's code:

```bash
flyer run --format=.
```

---

### Watch Mode

The `watch` command monitors your Flutter project for localization changes and automatically adds missing keys to `.arb` files.

```bash
flyer watch --loc [OPTIONS]
```

#### Available Options

| Option       | Description                                     | Default |
|--------------|-------------------------------------------------|---------|
| `--loc`      | Watch for missing localization keys and auto-add them (required). | `false` |
| `--debounce` | Debounce time in seconds.                       | `2`     |
| `--verbose, -v` | Show detailed logs.                          | `false` |

#### Example

```bash
flyer watch --loc
```

With verbose logging and custom debounce:

```bash
flyer watch --loc --verbose --debounce=5
```

This command:
- Watches `lib/` directory for `.dart` file changes.
- Runs `dart analyze` to detect missing `AppLocalizations` getters.
- Adds missing keys to all `.arb` files with language-appropriate defaults.
- Runs `flutter gen-l10n` to regenerate localization files.

---

### Deep Linking

The `deeplink` command sets up and tests deep linking for your Flutter app on both Android and iOS platforms.

#### Setup

```bash
flyer deeplink [OPTIONS]
```

##### Available Options

| Option          | Description                                              | Example Usage          |
|-----------------|----------------------------------------------------------|------------------------|
| `--domain, -d`  | Domain for App Links and Universal Links.                | `--domain=example.com` |
| `--scheme, -s`  | Custom URL scheme.                                       | `--scheme=myapp`       |
| `--dry-run`     | Show what will be done without making any changes.       |                        |

You must specify at least one of `--domain` or `--scheme`.

##### Example

```bash
flyer deeplink --domain=example.com --scheme=myapp
```

This command:
- Extracts project info (Android package name, iOS bundle ID, Team ID, SHA256 fingerprint).
- Updates `AndroidManifest.xml` with intent filters.
- Creates `assetlinks.json` for Android App Links verification.
- Creates `apple-app-site-association` for iOS Universal Links.
- Updates iOS `Info.plist` with URL schemes and deep linking settings.
- Generates `DeeplinkHandler` utility class (singleton) for handling deep links.
- Installs `app_links` package.

#### Testing Deep Links

```bash
flyer deeplink --test [OPTIONS]
```

##### Test Options

| Option      | Description                              | Example Usage                                  |
|-------------|------------------------------------------|------------------------------------------------|
| `--test`    | Enable test mode.                        |                                                |
| `--url`     | URL to test.                             | `--url=https://example.com/path`               |
| `--scheme`  | Custom URL scheme for test.              | `--scheme=myapp`                               |
| `--android` | Test on Android only.                    |                                                |
| `--ios`     | Show iOS test instructions.             |                                                |

##### Example

```bash
flyer deeplink --test --url=myapp://example.com/product/123 --android
```

#### Full Documentation

For complete setup instructions, testing, and advanced features (including Universal Links), see:
- [DEEPLINK_GUIDE.md](DEEPLINK_GUIDE.md) - Comprehensive deep linking documentation

---

### Find Unused Resources

The `fiend` command helps you identify and optionally delete unused assets, packages, and files in
your Flutter project.

```bash
flyer fiend [OPTIONS]
```

#### Available Options

| Option             | Description                           | Example Usage         |
|--------------------|---------------------------------------|-----------------------|
| `--unusedAssets`   | Find unused assets in your project.   | `--unusedAssets=.`    |
| `--unusedPackages` | Find unused packages in your project. | `--unusedPackages=.`  |
| `--unusedFiles`    | Find unused files in your project.    | `--unusedFiles=.`     |

> **Note:** These options require a value (e.g., `--unusedAssets=.`).

### Example Usage

#### Find Unused Assets

```bash
flyer fiend --unusedAssets=.
```

#### Find Unused Packages

```bash
flyer fiend --unusedPackages=.
```

#### Find Unused Files

```bash
flyer fiend --unusedFiles=.
```

---

## Contributing

Contributions are welcome! Here's how you can get involved:

1. Fork the repository.
2. Create a new branch (`feature/my-feature`).
3. Commit your changes.
4. Push to your branch.
5. Open a pull request.

Feel free to file issues or feature requests on the GitHub repository.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Additional Information

For more details, visit the [official Dart documentation](https://dart.dev/guides)
and [Flutter CLI documentation](https://flutter.dev/docs).
