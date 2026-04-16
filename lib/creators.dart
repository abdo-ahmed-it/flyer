import 'dart:io';

import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/helpers/updated_features_in_config.dart';
import 'package:flyer/samples/api_util_sample.dart';
import 'package:flyer/samples/app_feature_sample.dart';
import 'package:flyer/samples/extensions/context_extension_sample.dart';
import 'package:flyer/samples/home_sample.dart';
import 'package:flyer/samples/splash_feature_sample.dart';
import 'package:flyer/samples/splash_page_sample.dart';
import 'package:flyer/samples/utils/notification_util_sample.dart';

import 'core/creator_util.dart';
import 'core/extensions.dart';
import 'samples/app_colors_sample.dart';
import 'samples/app_config_sample.dart';
import 'samples/app_storage_sample.dart';
import 'samples/app_theme_sample.dart';
import 'samples/cubit_samples.dart';
import 'samples/feature_sample.dart';
import 'samples/form_sample.dart';
import 'samples/main_sample.dart';
import 'samples/page_sample.dart';
import 'samples/state_samples.dart';

class Creators {
  static var path = '${Directory.current.path}/lib';

  static void createFeature({String? name, String? pageS}) {
    String? featureName;
    if (name != null) {
      featureName = name;
    } else {
      stdout.write("${ColorsText.blue}Enter feature name: ${ColorsText.reset}");
      featureName = stdin.readLineSync();
    }
    updateFeaturesInConfigFile(featureName ?? '');

    CreatorUtil.createDirectory('$path/features');
    CreatorUtil.createDirectory('$path/features/$featureName');
    CreatorUtil.createDirectory('$path/features/$featureName/actions');
    CreatorUtil.createDirectory('$path/features/$featureName/bloc');
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/${featureName}_feature.dart',
        featureSample(featureName!));
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/${featureName}_page.dart',
        pageS ?? pageSample(featureName));
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/bloc/${featureName}_state.dart',
        stateSample(featureName));
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/bloc/${featureName}_bloc.dart',
        cubitSample(featureName));
  }

  static void _createSplashFeature() {
    String? featureName = 'splash';

    updateFeaturesInConfigFile(featureName);

    CreatorUtil.createDirectory('$path/features');
    CreatorUtil.createDirectory('$path/features/$featureName');
    CreatorUtil.createDirectory('$path/features/$featureName/actions');
    CreatorUtil.createDirectory('$path/features/$featureName/bloc');
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/${featureName}_feature.dart',
        splashFeatureSample());
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/${featureName}_page.dart',
        splashPageSample());
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/bloc/${featureName}_state.dart',
        stateSample(featureName));
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/bloc/${featureName}_bloc.dart',
        cubitSample(featureName));
  }

  static Future<void> addPage({String? featureName, String? routeName}) async {
    if (featureName == null) {
      stdout.write("${ColorsText.blue}Enter feature name: ${ColorsText.reset}");
      featureName = stdin.readLineSync();
    }
    if (routeName == null) {
      stdout.write("${ColorsText.blue}Enter route name: ${ColorsText.reset}");
      routeName = stdin.readLineSync();
    }

    String content = await CreatorUtil.readFileContent(
        '$path/features/$featureName/${featureName}_feature.dart');

    // Find the routes list using regex
    final routesRegex = RegExp(
      r'List<GoRoute>\s+get\s+routes\s*=>\s*\[(.*?)\];',
      dotAll: true,
    );
    final match = routesRegex.firstMatch(content);

    if (match != null) {
      CreatorUtil.createDirectory('$path/features/$featureName/pages');
      CreatorUtil.createFileWithContent(
          '$path/features/$featureName/pages/${routeName}_page.dart',
          pageSample(routeName ?? ''));

      final existingRoutes = match.group(1)?.trim() ?? '';
      final routeNameCamelCase = '_$routeName';
      final routeNameCapitalized = routeName?.toCapitalized ?? '';

      // Create new route with proper formatting
      String newRoute = '''GoRoute(
      path: $routeNameCamelCase,
      name: $routeNameCamelCase,
      builder: (_, state) => const ${routeNameCapitalized}Page(),
    )''';

      // Combine routes with proper formatting
      String updatedRoutes;
      if (existingRoutes.isEmpty) {
        updatedRoutes = '\n    $newRoute,\n  ';
      } else {
        // Remove trailing comma and whitespace from existing routes
        String cleanedRoutes = existingRoutes.trimRight();
        if (!cleanedRoutes.endsWith(',')) {
          cleanedRoutes += ',';
        }
        updatedRoutes = '$cleanedRoutes\n    $newRoute,\n  ';
      }

      // Replace the routes list
      content = content.replaceFirst(
        routesRegex,
        'List<GoRoute> get routes => [$updatedRoutes];',
      );

      // Add private getter after name getter
      final nameGetterRegex = RegExp(
        r"(String\s+get\s+name\s*=>\s*'[^']*';)",
        multiLine: true,
      );
      final nameMatch = nameGetterRegex.firstMatch(content);

      if (nameMatch != null) {
        final insertPosition = nameMatch.end;
        final privateGetter = "\n\n  String get $routeNameCamelCase => '/$routeName';";
        content = content.substring(0, insertPosition) +
                  privateGetter +
                  content.substring(insertPosition);
      }

      // Add push function before the closing brace
      final closingBraceIndex = content.lastIndexOf('}');
      if (closingBraceIndex != -1) {
        final pushFunction = "\n\n  void push${routeNameCapitalized}() => push(name: $routeNameCamelCase);\n";
        content = content.substring(0, closingBraceIndex) +
                  pushFunction +
                  content.substring(closingBraceIndex);
      }

      // Add import at the top
      content = '''import 'pages/${routeName}_page.dart';\n$content''';

      CreatorUtil.editFileContent(
          '$path/features/$featureName/${featureName}_feature.dart', content);
    } else {
      print(
          '${ColorsText.red}✗ Could not find routes list in feature file${ColorsText.reset}');
    }
  }

  static Future<void> addLang({List<String>? languages}) async {
    if (languages == null) {
      stdout.write(
          "${ColorsText.blue}Enter app languages (e.g., ar,en): ${ColorsText.reset}");
      languages = stdin.readLineSync()?.split(',') ?? ['ar'];
    }
    String content = await CreatorUtil.readFileContent(
        '${Directory.current.path}/pubspec.yaml');
    if (!content.contains('flutter_localizations')) {
      content = content.replaceFirst(
          'dependencies:', '''dependencies:\n  flutter_localizations:
    sdk: flutter''');
      CreatorUtil.editFileContent(
          '${Directory.current.path}/pubspec.yaml', '$content  generate: true',
          canFormated: false);
    }

    CreatorUtil.createDirectory('$path/l10n');
    for (String code in languages) {
      CreatorUtil.createFileWithContent(
          '$path/l10n/app_$code.arb', '{"home":"$code"}',
          canFormated: false);
    }
    CreatorUtil.createFileWithContent(
        '${Directory.current.path}/l10n.yaml',
        '''
arb-dir: lib/l10n
template-arb-file: app_ar.arb
output-localization-file: app_localizations.dart
  ''',
        canFormated: false);
  }

  static void _createAppFolder() {
    CreatorUtil.createDirectory('$path/app');
    CreatorUtil.createDirectory('$path/app/utils');
    CreatorUtil.createFileWithContent(
        '$path/app/utils/notification_util.dart', notificationsUtilSample());
    CreatorUtil.createDirectory('$path/app/data');
    CreatorUtil.createDirectory('$path/app/models');
    CreatorUtil.createDirectory('$path/app/bloc');
    CreatorUtil.createFileWithContent(
        '$path/app/app_feature.dart', appFeatureSample());
    CreatorUtil.createFileWithContent(
        '$path/app/bloc/app_bloc.dart', cubitSample('app'));
    CreatorUtil.createFileWithContent(
        '$path/app/bloc/app_state.dart', stateSample('app'));
  }

  static void _createThemeFolder() {
    CreatorUtil.createDirectory('$path/theme');
    CreatorUtil.createFileWithContent(
        '$path/theme/app_theme.dart', appThemeSample());
    CreatorUtil.createFileWithContent(
        '$path/theme/app_colors.dart', appColorsSample());
  }

  static void _createConfigFolder() {
    CreatorUtil.createDirectory('$path/config');
    CreatorUtil.createFileWithContent(
        '$path/config/app_config.dart', appConfigSample());
  }

  static Future<void> _createCoreFolder() async {
    CreatorUtil.createDirectory('$path/core');
    CreatorUtil.createDirectory('$path/core/extensions');
    CreatorUtil.createDirectory('$path/core/utils');
    CreatorUtil.createFileWithContent(
        '$path/core/app_storage.dart', appStorageSample());
    CreatorUtil.createFileWithContent(
        '$path/core/extensions/context_extension.dart',
        contextExtensionSample());
    String getApiSample = await apiUtilSample();
    CreatorUtil.createFileWithContent(
        '$path/core/utils/api_util.dart', getApiSample);
  }

  static Future<void> _createInitFeature() async {
    _createSplashFeature();
    String homeSampleContent = await homeSample();

    createFeature(name: 'home', pageS: homeSampleContent);
  }

  static Future<void> init() async {
    _createAppFolder();
    _createThemeFolder();
    _createConfigFolder();
    await _createCoreFolder();
    await _createInitFeature();
    CreatorUtil.editFileContent('$path/main.dart', mainSample());
  }

  static void addForm({
    List<String>? fields,
    String? featureName,
    String? formName,
  }) {
    if (featureName == null) {
      stdout.write("${ColorsText.blue}Enter feature name: ${ColorsText.reset}");
      featureName = stdin.readLineSync();
    }

    if (formName == null) {
      stdout.write("${ColorsText.blue}Enter form name: ${ColorsText.reset}");
      formName = stdin.readLineSync();
    }
    if (fields == null) {
      stdout.write(
          "${ColorsText.blue}Enter form fields (comma-separated): ${ColorsText.reset}");
      fields = stdin.readLineSync()?.split(',');
    }
    CreatorUtil.createDirectory('$path/features/$featureName/forms');
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/forms/${formName}_form.dart',
        formSample(formName ?? 'A', fields ?? []));
  }
}
