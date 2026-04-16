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
import 'samples/app_bloc_sample.dart';
import 'samples/bottom_nav_data_sample.dart';
import 'samples/bottom_nav_item_model_sample.dart';
import 'samples/master_page_sample.dart';
import 'samples/onboarding/onboarding_data_sample.dart';
import 'samples/onboarding/onboarding_feature_sample.dart';
import 'samples/onboarding/onboarding_model_sample.dart';
import 'samples/onboarding/onboarding_page_sample.dart';
import 'samples/app_notifications_sample.dart';
import 'samples/app_styles_sample.dart';
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

  static void _createSplashFeature({bool onboarding = false}) {
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
        splashPageSample(onboarding: onboarding));
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

  static Future<void> _createAppFolder({bool firebase = false}) async {
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
        '$path/app/bloc/app_bloc.dart', appBlocSample(firebase: firebase));
    CreatorUtil.createFileWithContent(
        '$path/app/bloc/app_state.dart', appStateSample());
    CreatorUtil.createFileWithContent(
        '$path/app/models/bottom_nav_item_model.dart',
        bottomNavItemModelSample());
    String navData = await bottomNavDataSample();
    CreatorUtil.createFileWithContent(
        '$path/app/data/bottom_nav_data.dart', navData);
    String masterPage = await masterPageSample();
    CreatorUtil.createFileWithContent(
        '$path/app/master_page.dart', masterPage);
  }

  static void _createThemeFolder() {
    CreatorUtil.createDirectory('$path/theme');
    CreatorUtil.createFileWithContent(
        '$path/theme/app_theme.dart', appThemeSample());
    CreatorUtil.createFileWithContent(
        '$path/theme/app_colors.dart', appColorsSample());
    CreatorUtil.createFileWithContent(
        '$path/theme/app_styles.dart', appStylesSample());
  }

  static void _createConfigFolder() {
    CreatorUtil.createDirectory('$path/config');
    CreatorUtil.createFileWithContent(
        '$path/config/app_config.dart', appConfigSample());
  }

  static Future<void> _createCoreFolder({bool firebase = false}) async {
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
    if (firebase) {
      CreatorUtil.createFileWithContent(
          '$path/core/app_notifications.dart', appNotificationsSample());
    }
  }

  static Future<void> _createOnboardingFeature() async {
    String featureName = 'on_boarding';
    updateFeaturesInConfigFile(featureName);

    CreatorUtil.createDirectory('$path/features/$featureName');
    CreatorUtil.createDirectory('$path/features/$featureName/model');
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/on_boarding_feature.dart',
        onboardingFeatureSample());
    String onboardingPage = await onboardingPageSample();
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/onboarding_page.dart', onboardingPage);
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/model/onboarding_model.dart',
        onboardingModelSample());
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/model/onboarding_data.dart',
        onboardingDataSample());
  }

  static Future<void> _createInitFeature({bool onboarding = false}) async {
    _createSplashFeature(onboarding: onboarding);
    String homeSampleContent = await homeSample();

    createFeature(name: 'home', pageS: homeSampleContent);
    createFeature(name: 'account');

    if (onboarding) {
      await _createOnboardingFeature();
    }
  }

  static void _copyFonts() {
    final projectRoot = Directory.current.path;
    final fontsDir = Directory('$projectRoot/assets/fonts');
    CreatorUtil.createDirectory(fontsDir.path);

    // Find the flyer package path from package_config.json
    final packageConfigFile =
        File('$projectRoot/.dart_tool/package_config.json');
    if (!packageConfigFile.existsSync()) return;

    final content = packageConfigFile.readAsStringSync();
    // Match the flyer package entry
    final flyerRegex = RegExp(
      r'"name":\s*"flyer"[^}]*"rootUri":\s*"([^"]*)"',
      dotAll: true,
    );
    final match = flyerRegex.firstMatch(content);
    if (match == null) return;

    var rootUri = match.group(1)!;
    String flyerPath;
    if (rootUri.startsWith('file://')) {
      flyerPath = Uri.parse(rootUri).toFilePath();
    } else {
      // Relative path - resolve from .dart_tool directory
      flyerPath = File('$projectRoot/.dart_tool/$rootUri')
          .resolveSymbolicLinksSync();
    }

    final sourceFontsDir = Directory('$flyerPath/lib/assets/fonts');
    if (sourceFontsDir.existsSync()) {
      for (var font in sourceFontsDir.listSync()) {
        if (font is File && font.path.endsWith('.ttf')) {
          final destFile =
              File('${fontsDir.path}/${font.path.split('/').last}');
          if (!destFile.existsSync()) {
            font.copySync(destFile.path);
            print(
                '${ColorsText.green}  \u2713${ColorsText.reset} Copied font: ${ColorsText.cyan}${destFile.path}${ColorsText.reset}');
          }
        }
      }
    }

  }

  static Future<void> _addFontsToPublicSpec() async {
    final pubspecPath = '${Directory.current.path}/pubspec.yaml';
    String content = await CreatorUtil.readFileContent(pubspecPath);

    if (!content.contains('family: Almarai')) {
      final fontsConfig = '''
  fonts:
    - family: Almarai
      fonts:
        - asset: assets/fonts/Almarai-Light.ttf
          weight: 100
        - asset: assets/fonts/Almarai-Regular.ttf
          weight: 400
        - asset: assets/fonts/Almarai-Bold.ttf
          weight: 600
  assets:
    - assets/fonts/''';

      content = content.replaceFirst(
        'uses-material-design: true',
        'uses-material-design: true\n$fontsConfig',
      );
      CreatorUtil.editFileContent(pubspecPath, content, canFormated: false);
    }
  }

  static Future<void> init({bool firebase = false, bool onboarding = false}) async {
    await _createAppFolder(firebase: firebase);
    _createThemeFolder();
    _createConfigFolder();
    await _createCoreFolder(firebase: firebase);
    await _createInitFeature(onboarding: onboarding);
    _copyFonts();
    await _addFontsToPublicSpec();
    CreatorUtil.editFileContent(
        '$path/main.dart', mainSample(firebase: firebase));
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
