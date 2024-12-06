```markdown
# flyer 🛠️

A powerful CLI package to speed up Flutter app development by automating repetitive tasks like
creating features, pages, forms, and generating Dart model classes from JSON and and reformatting
code and more. Additionally, it initializes your Flutter project's infrastructure and installs
essential packages.

With `flyer`, you can streamline your development process, reduce boilerplate code, and focus
on building your app's core features.

---

## Features 🚀

- **Project Initialization**: Set up the infrastructure of your Flutter project and install
  essential packages.
- **Feature Generation**: Generate fully-structured Flutter features.
- **Language Support**: Add multiple languages to your app with ease.
- **Model Generation**: Generate Dart classes directly from JSON data.
- **Page Generation**: Add pages to specific features.
- **Form Generation**: Generate forms with custom fields.
- **Code Formatting**: Reformat your code for consistency.
- **Unused Resources Finder**: Identify and optionally delete unused assets, packages, and files.

---

## Installation 📦

Add the following dependency to your `pubspec.yaml`:

```yaml
dev_dependencies:
  flyer: <latest version>
```

Run the following command to install:

```bash
dart pub get
```

---

## Usage 📝

### Init Command

The `init` command sets up the basic infrastructure for your Flutter project and installs essential
packages.

```bash
dart run flyer init [OPTIONS]
```

#### Available Options

| Option   | Description                          | Example Usage     |
|----------|--------------------------------------|-------------------|
| `--lang` | Add languages during initialization. | `--lang=en,ar,fr` |

#### Example

```bash
dart run flyer init --lang=en,ar
```

This command:

- Sets up the basic infrastructure for your Flutter project.
- Installs essential packages (e.g., `app_features`, `flutter_bloc`, etc.).
- Adds the specified languages (`en` and `ar`) to the project.

---

### Make Command

The `make` command allows you to create features, pages, models, forms, and manage languages for
your Flutter project.

```bash
dart run flyer make [OPTIONS]
```

#### Available Options

| Option          | Description                             | Example Usage                                  |
|-----------------|-----------------------------------------|------------------------------------------------|
| `--feature, -f` | Create a new feature.                   | `--feature=myFeature`                          |
| `--lang`        | Add multiple languages to the app.      | `--lang=en,ar`                                 |
| `--model, -m`   | Generate a Dart class from JSON.        | `--model=UserModel --json='{"name": "ahmed"}'` |
| `--page`        | Create a page within a feature.         | `--page=homePage --feature=myFeature`          |
| `--form`        | Create a form with fields in a feature. | `--form=login --fields=password,email`         |

### Examples

#### Create a New Feature

```bash
dart run flyer make --feature=account
```

#### Add Multiple Languages

```bash
dart run flyer make --lang=en,fr,es
```

#### Generate a Dart Model from JSON Default Path app/models

```bash
dart run flyer make --model=User --json='{"name": "John", "age": 30}'
```

#### Generate a Dart Model from JSON With Custom Path

```bash
dart run flyer make --model=User --json='{"name": "John", "age": 30}' --path=custom_path
```

#### Generate a Page

```bash
dart run flyer make --page=login --feature=account
```

#### Generate a Form

```bash
dart run flyer make --form=login --feature=account --fields=email,password
```

---

### Run Utility Tasks

The `run` command provides utility tasks like reformatting your project's code.

```bash
dart run flyer run [OPTIONS]
```

#### Available Options

| Option     | Description                  | Example Usage |
|------------|------------------------------|---------------|
| `--format` | Reformat the project's code. | `--format`    |

#### Example

To format your project's code:

```bash
dart run flyer run --format
```

---

### Find Unused Resources

The `fiend` command helps you identify and optionally delete unused assets, packages, and files in
your Flutter project.

```bash
dart run flyer fiend [OPTIONS]
```

#### Available Options

| Option             | Description                           | Example Usage       |
|--------------------|---------------------------------------|---------------------|
| `--unusedAssets`   | Find unused assets in your project.   | ` --unusedAssets`   |
| `--unusedPackages` | Find unused packages in your project. | ` --unusedPackages` |
| `--unusedFiles`    | Find unused files in your project.    | ` --unusedPackages` |

### Example Usage

#### Find Unused Assets

```bash
dart run flyer fiend --unusedAssets
```

#### Find Unused Packages

```bash
dart run flyer fiend --unusedPackages
```

#### Find Unused Files

```bash
dart run flyer fiend --unusedFiles
```

## Contributing 🤝

Contributions are welcome! Here's how you can get involved:

1. Fork the repository.
2. Create a new branch (`feature/my-feature`).
3. Commit your changes.
4. Push to your branch.
5. Open a pull request.

Feel free to file issues or feature requests on the GitHub repository.

---

## License 📄

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Additional Information 📚

For more details, visit the [official Dart documentation](https://dart.dev/guides)
and [Flutter CLI documentation](https://flutter.dev/docs).

---

Happy coding! 😊

```
