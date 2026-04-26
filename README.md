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
- **CI/CD for iOS**: One-command scaffolding of GitHub Actions + Fastlane pipeline
  that ships your app to TestFlight (with optional Shorebird code push).
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

| Option         | Description                          | Example Usage     |
|----------------|--------------------------------------|-------------------|
| `--lang`       | Add languages during initialization (defaults to `en,ar`). | `--lang=en,ar,fr` |
| `--firebase`   | Setup Firebase (installs `firebase_core` and runs `flutterfire configure`). | `--firebase` |
| `--onboarding` | Add onboarding feature with intro screens. | `--onboarding` |

#### Examples

```bash
flyer init --lang=en,ar,de
```

With Firebase and Onboarding:

```bash
flyer init --firebase --onboarding
```

This command:

- Sets up the basic infrastructure for your Flutter project with three default features: `splash`, `home`, and `account`.
- Generates a **MasterPage** with a modern floating bottom navigation bar (animated, dark mode support, haptic feedback).
- Generates **AppBloc/AppState** with tab navigation management.
- Generates **BottomNavData** and **BottomNavItemModel** for easy tab configuration.
- Generates **AppStyles** with full text style system (thin, light, regular, medium, semibold, bold) using Almarai font.
- Copies **Almarai font files** to `assets/fonts/` and configures them in `pubspec.yaml`.
- Installs essential packages (`app_features`, `api_request`, `equatable`, `hive_flutter`, `get_it`, `flutter_bloc`, `flutter_easyloading`, `toastification`, `responsive_framework`, `app_forms`, `requests_inspector`).
- **Automatically adds Arabic (`ar`) and English (`en`) languages by default**.
- **Automatically installs `requests_inspector` package for API debugging**.
- Adds any additional languages specified with `--lang` option.
- Displays Messages, Dialogs, and BottomSheet without context.
- Handles app responsiveness using `responsive_framework` package.
- Initializes API configuration using `api_request` package.
- Manages Routes using `go_router` package (via `app_features`).
- **With `--firebase`**: Installs `firebase_core`, adds `Firebase.initializeApp()` to `main.dart`, and runs `flutterfire configure` interactively.
- **With `--onboarding`**: Adds an onboarding feature with PageView intro screens, dot indicators, and skip/next navigation. Shown only on first launch.

#### Generated Structure

```
lib/
├── app/
│   ├── app_feature.dart          # AppFeature with MasterPage route
│   ├── master_page.dart          # Floating bottom nav bar with IndexedStack
│   ├── bloc/
│   │   ├── app_bloc.dart         # Tab index management
│   │   └── app_state.dart        # App state with currentIndex
│   ├── data/
│   │   └── bottom_nav_data.dart  # Tab items configuration
│   ├── models/
│   │   └── bottom_nav_item_model.dart
│   └── utils/
│       └── notification_util.dart
├── config/app_config.dart
├── core/
│   ├── app_storage.dart          # Hive-based storage
│   ├── extensions/
│   └── utils/api_util.dart
├── theme/
│   ├── app_theme.dart
│   ├── app_colors.dart
│   └── app_styles.dart           # Full text style system
├── features/
│   ├── splash/                   # Splash -> MasterPage (or Onboarding)
│   ├── home/
│   ├── account/
│   └── on_boarding/              # (with --onboarding flag)
├── l10n/
└── main.dart
assets/
└── fonts/                        # Almarai font files
```

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

### iOS CI/CD (TestFlight via GitHub Actions + Fastlane)

The `ci ios` command scaffolds a **production-ready** deployment pipeline
that ships your Flutter iOS app to TestFlight on demand. It auto-detects
your **Bundle ID** and **Team ID** from `ios/Runner.xcodeproj`, then writes
the GitHub Actions workflow, Fastlane config, and a few project-level
patches so you can `Run workflow` from GitHub on day one.

```bash
# Native deploy (Fastlane match + build_app + pilot)
flyer ci ios --match-git-url https://github.com/you/ios_cer.git

# Same + Shorebird code push (runs `shorebird init` if needed)
flyer ci ios --shorebird --match-git-url https://github.com/you/ios_cer.git

# Preview changes without writing anything
flyer ci ios --dry-run --shorebird
```

#### What it generates

| File                                          | Purpose                                                       |
| --------------------------------------------- | ------------------------------------------------------------- |
| `.github/workflows/deploy.yml`                | macos-26 + Xcode 26.1.1, hardened, SHA-pinned actions         |
| `.github/dependabot.yml`                      | Weekly grouped PRs to keep action SHAs current                |
| `ios/fastlane/Fastfile`                       | 5 lanes (see below) with flavor support                       |
| `ios/fastlane/Appfile`                        | Bundle identifier                                              |
| `ios/fastlane/Matchfile`                      | Points at your shared certificates repo                        |
| `ios/fastlane/.env.example`                   | Stub for local lane runs (real `.env` is gitignored)          |
| `ios/fastlane/Pluginfile` *(`--shorebird`)*   | `fastlane-plugin-shorebird`                                    |
| `ios/ExportOptions.plist`                     | Manual signing config for the IPA export                       |
| `ios/Gemfile`                                 | `fastlane` + `cocoapods` + Pluginfile eval                     |

It also patches the project in place:
- `ios/Podfile` — `post_install` block tuned for Flutter + Firebase + Xcode 16/26.
- `ios/Runner/Info.plist` — adds `ITSAppUsesNonExemptEncryption=false`
  so TestFlight stops asking the export-compliance question on every build.
- `ios/Runner.xcodeproj/.../Runner.xcscheme` — empties `<Testables>` and sets
  `buildForTesting="NO"` so `xcodebuild archive` doesn't probe a missing
  iOS simulator runtime on macos-26 (which causes "Unable to connect to
  simulator" / exit 70).
- `.gitignore` — appends Fastlane artifacts and `ios/fastlane/.env*`.
- `android/app/src/main/AndroidManifest.xml` *(`--shorebird` only)* — adds
  `INTERNET` permission required by the Shorebird updater.

#### Workflow inputs

The generated workflow runs only on `workflow_dispatch` (manual trigger).
Two inputs:

| Input    | Choices                                                                | Notes                                                                                |
| -------- | ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `lane`   | `release_shorebird`, `patch_shorebird`, `deploy`, `sync_profile`, `upload_only` | Default = `release_shorebird` if `--shorebird`, else `deploy`.            |
| `flavor` | `prod`, `dev`                                                          | Picks the entry point: `lib/main_<flavor>.dart`. `prod` is the default.              |

#### Fastlane lanes

| Lane                | What it does                                                                                              |
| ------------------- | --------------------------------------------------------------------------------------------------------- |
| `deploy`            | Native build via Fastlane `gym` → upload to TestFlight. Runs `flutter build ios --config-only -t main_<flavor>.dart` first so `xcode_backend.sh` picks up the right entry point. |
| `release_shorebird` | Shorebird release (signed IPA + Shorebird patch baseline) → upload to TestFlight. Required before `patch_shorebird` works. |
| `patch_shorebird`   | Ships a Dart-only OTA patch to existing users — **no App Store review, no native rebuild**. ~2 min.       |
| `sync_profile`      | One-shot lane: creates/refreshes the cert + provisioning profile in your match repo. Run this **once** per new bundle id, then never again. |
| `upload_only`       | Re-upload a previously built `Runner.ipa` to TestFlight. Useful for retrying a flaky network upload without rebuilding. |

#### Workflow optimizations baked in

- **`permissions: {}`** at workflow level + `contents: read` per job (least-privilege).
- **SHA-pinned** action references (`actions/checkout@<sha> # v6`, etc.) — Dependabot keeps them updated.
- **Concurrency group** prevents two runs racing on the TestFlight build number.
- **Skips Xcode setup, Pod install, and IPA upload** when running `patch_shorebird` — that lane is Dart-only.
- **Caches**: pub, CocoaPods, **Xcode DerivedData** (`irgaly/xcode-cache` saves 3–8 min on warm runs), Bundler.
- **Cache keys include `FLUTTER_VERSION`** so a Flutter upgrade automatically invalidates the Pods cache.
- **TestFlight upload** uses `reject_build_waiting_for_review: true` so a stuck pending-review build doesn't block the new one.
- **Lark notifications** ship with the workflow — set `LARK_WEBHOOK` in secrets to enable, leave unset to skip silently.

#### Flags

| Flag                 | Purpose                                                       |
| -------------------- | ------------------------------------------------------------- |
| `--shorebird`        | Enable Shorebird code push (runs `shorebird init` if needed). |
| `--match-git-url`    | Fastlane match certificates repo (prompted if omitted).       |
| `--bundle-id`        | Override the auto-detected bundle identifier.                 |
| `--team-id`          | Override the auto-detected Apple Developer Team ID.           |
| `--dry-run`          | Show planned changes without writing files.                   |
| `-y`, `--yes`        | Skip the confirmation prompt.                                 |

#### Setup (after running `flyer ci ios`)

**1. One-time Apple Developer setup**

- Register the bundle id in [Apple Developer → Identifiers](https://developer.apple.com/account/resources/identifiers/list).
- Create the app in [App Store Connect](https://appstoreconnect.apple.com).
- Generate an [App Store Connect API key (`.p8`)](https://appstoreconnect.apple.com/access/api) — keep the file safe; it's shown only once.

**2. Add GitHub Secrets** (Settings → Secrets and variables → Actions)

| Secret                              | Required | Notes                                                                       |
| ----------------------------------- | :------: | --------------------------------------------------------------------------- |
| `APP_STORE_CONNECT_API_KEY_ID`      |    ✅    |                                                                             |
| `APP_STORE_CONNECT_API_ISSUER_ID`   |    ✅    |                                                                             |
| `APP_STORE_CONNECT_API_KEY_CONTENT` |    ✅    | **base64 of your `.p8`** — `base64 -i AuthKey_XXX.p8 \| pbcopy`             |
| `MATCH_PASSWORD`                    |    ✅    | Any strong password; used to encrypt the match repo. Reuse across projects. |
| `MATCH_GIT_URL`                     |    ✅    | URL of your match certificates repo (e.g. `https://github.com/you/ios_cer.git`). |
| `MATCH_GIT_BASIC_AUTHORIZATION`     |    ⚙️    | Only if the match repo is private. **base64 of `user:PAT`**.                |
| `KEYCHAIN_PASSWORD`                 |    ✅    | Any random string. Used for the temporary CI keychain.                      |
| `SHOREBIRD_TOKEN`                   |    ⚙️    | Only with `--shorebird`. From [Shorebird Console → API Keys](https://console.shorebird.dev). |
| `LARK_WEBHOOK`                      |    ⚙️    | Optional. URL of a Lark/Feishu bot incoming webhook for build notifications. |

> Projects sharing the same Apple Developer Team can reuse the same match
> repo + `MATCH_PASSWORD`, so most of these secrets only need to be created
> **once per Apple Team**, not per project.

**3. Create the cert + provisioning profile (one-shot)**

Two paths — pick whichever is easier:

- **From CI** (recommended for fresh bundle ids):
  GitHub → Actions → "Deploy iOS to TestFlight" → Run workflow →
  `lane: sync_profile`. This generates the Apple Distribution cert and
  the App Store provisioning profile, then commits them encrypted to your
  match repo. Subsequent runs use them in `readonly` mode.

- **Locally**: copy `ios/fastlane/.env.example` to `ios/fastlane/.env`,
  fill in the same values you put in GitHub Secrets, then:
  ```bash
  cd ios
  bundle install
  bundle exec fastlane sync_profile
  ```

**4. Ship a build**

GitHub → Actions → "Deploy iOS to TestFlight" → Run workflow:

| Lane                | When to use                                                         |
| ------------------- | ------------------------------------------------------------------- |
| `release_shorebird` | Default. Native build + Shorebird baseline. Required after any native change (Pods, Info.plist, native code). |
| `patch_shorebird`   | Only after `release_shorebird` succeeded. Dart-only changes — ~2 min. |
| `deploy`            | Native build without Shorebird. Use if you don't have Shorebird set up. |

#### Cost / runner notes

- macOS runners cost **10×** the minutes of Linux runners on private repos.
  GitHub Free tier (2,000 minutes/month) ≈ **200 macOS minutes** ≈ **~30
  warm-cache `release_shorebird` runs** or **~80 `patch_shorebird` runs**.
- Public repos get unlimited minutes — no quota.
- `patch_shorebird` is the cheapest lane by ~3× because it skips the iOS native build entirely.

#### Troubleshooting

- **"No matching provisioning profiles found"** — your match repo doesn't
  have a profile for this bundle id yet. Run `lane: sync_profile` once.
- **"Unable to connect to simulator" / exit 70** — should not happen on a
  freshly-scaffolded project; the scheme patch handles it. If it reappears
  after a `flutter create` overwrite, re-run `flyer ci ios` to re-apply the
  patch.
- **`Gemfile.lock` "frozen mode" error in Set up Ruby** — run
  `cd ios && bundle install` locally and commit the regenerated `Gemfile.lock`.
- **Build hangs at "Waiting for build processing"** — already mitigated via
  `skip_waiting_for_build_processing: true`. If it happens anyway, use
  `lane: upload_only` to retry the upload of an existing `Runner.ipa`.

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
