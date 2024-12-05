# app_creator 🛠️

A powerful CLI package to speed up Flutter app development by automating repetitive tasks like
creating features, pages, forms, and generating Dart model classes from JSON.

With `app_creator`, you can streamline your development process, reduce boilerplate code, and focus
on building your app's core features.

---

## Features 🚀

- **Feature Creation**: Generate fully-structured Flutter features.
- **Language Support**: Add multiple languages to your app with ease.
- **Model Generation**: Create Dart classes directly from JSON data.
- **Page Creation**: Add pages to specific features.
- **Form Generation**: Generate forms with custom fields.
- **Customizable Paths**: Control where generated files are stored.

---

## Installation 📦

Add the following dependency to your `pubspec.yaml`:

```yaml
dev_dependencies:
  app_creator: ^1.0.0
Run the following command to install:

bash
Copy code
dart pub get
Usage 📝
To use the package, run the following command:

bash
Copy code
dart run app_creator make [OPTIONS]
Available Options
Option	Description	Example Usage
--feature, -f	Create a new feature.	dart run app_creator make --feature=myFeature
--lang	Add multiple languages to the app.	dart run app_creator make --lang=en,ar
--model, -m	Generate a Dart class from JSON.	dart run app_creator make --model=UserModel --json='{"name": "ahmed"}'
--page	Create a page within a feature.	dart run app_creator make --page=homePage --feature=myFeature
--form	Create a form with fields in a feature.	dart run app_creator make --form=loginForm --fields=username,password,email
--fields	Specify fields for forms (comma-separated).	--fields=username,password,email
--json	Provide JSON data for model generation.	--json='{"name": "John", "age": 30}'
--path	Specify a path for the generated model file.	--path=lib/models/
Examples
Create a New Feature
bash
Copy code
dart run app_creator make --feature=authentication
Add Multiple Languages
bash
Copy code
dart run app_creator make --lang=en,fr,es
Generate a Dart Model from JSON
bash
Copy code
dart run app_creator make --model=User --json='{"name": "John", "age": 30}'
Create a Page
bash
Copy code
dart run app_creator make --page=dashboard --feature=analytics
Generate a Form
bash
Copy code
dart run app_creator make --form=registration --feature=users --fields=name,email,password
Getting Started 🛠️
Install the package (see the Installation section).
Use the make command with appropriate options to generate features, pages, models, or forms.
Check the generated files in your Flutter project directory.
Contributing 🤝
Contributions are welcome! Here's how you can get involved:

Fork the repository.
Create a new branch (feature/my-feature).
Commit your changes.
Push to your branch.
Open a pull request.
Feel free to file issues or feature requests on the GitHub repository.

License 📄
This project is licensed under the MIT License. See the LICENSE file for details.

Additional Information 📚
For more details, visit the official Dart documentation and Flutter CLI documentation.

Why Use app_creator?
Saves time by automating repetitive tasks.
Provides consistent structure across your Flutter projects.
Makes collaboration easier with standardized generated code.
Lightweight and easy to use.
