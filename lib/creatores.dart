import 'dart:io';

import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/helpers/updated_features_in_config.dart';
import 'package:flyer/samples/app_feature_sample.dart';
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

  static void createFeature({String? name}) {
    String? featureName;
    if (name != null) {
      featureName = name;
    } else {
      stdout.write(
          "${ColorsText.blue}Enter Your Name Feature : ${ColorsText.reset}");
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
        pageSample(featureName));
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

  static void addPage({String? featureName, String? routeName}) async {
    if (featureName == null) {
      stdout.write(
          "${ColorsText.blue}Enter Your Name Feature : ${ColorsText.reset}");
      featureName = stdin.readLineSync();
    }
    if (routeName == null) {
      stdout.write(
          "${ColorsText.blue}Enter Your Name Route : ${ColorsText.reset}");
      routeName = stdin.readLineSync();
    }

    String content = await CreatorUtil.readFileContent(
        '$path/features/$featureName/${featureName}_feature.dart');
    // Find the position of the opening and closing brackets
    int startIndex = content.indexOf('[');
    int endIndex = content.indexOf(']');

    // Extract the content between the brackets
    if (startIndex != -1 && endIndex != -1) {
      CreatorUtil.createDirectory('$path/features/$featureName/pages');
      CreatorUtil.createFileWithContent(
          '$path/features/$featureName/pages/${routeName}_page.dart',
          pageSample(routeName ?? ''));
      List<String> oldRoutes =
          content.substring(startIndex + 1, endIndex).split(',');

      String routeAdded =
          '''GoRoute(path: '/$routeName', name:  '/$routeName', builder: (_, state) => const ${routeName?.toCapitalized}Page())''';
      List<String> routes = [];
      routes.addAll(oldRoutes);
      routes.add(routeAdded);
      content = content.replaceRange(
        startIndex,
        endIndex + 1,
        routes.toString(),
      );
      content = '''import 'pages/${routeName}_page.dart';\n
$content''';
      CreatorUtil.editFileContent(
          '$path/features/$featureName/${featureName}_feature.dart', content);
    } else {
      print('No brackets found');
    }
  }

  static Future<void> addLang({List<String>? languages}) async {
    if (languages == null) {
      stdout.write(
          "${ColorsText.blue} Enter Your App Languages as Like This ar,en,... : ${ColorsText.reset}");
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

  static void _createCoreFolder() {
    CreatorUtil.createDirectory('$path/core');
    CreatorUtil.createFileWithContent(
        '$path/core/app_storage.dart', appStorageSample());
  }

  static void _createInitFeature() {
    _createSplashFeature();
    createFeature(name: 'home');
  }

  static void init() {
    _createAppFolder();
    _createThemeFolder();
    _createConfigFolder();
    _createCoreFolder();
    _createInitFeature();
    CreatorUtil.editFileContent('$path/main.dart', mainSample());
  }

  static void addForm({
    List<String>? fields,
    String? featureName,
    String? formName,
  }) {
    if (featureName == null) {
      stdout.write(
          "${ColorsText.blue}Enter Your Name Feature : ${ColorsText.reset}");
      featureName = stdin.readLineSync();
    }

    if (formName == null) {
      stdout.write(
          "${ColorsText.blue}Enter Your Name Form : ${ColorsText.reset}");
      formName = stdin.readLineSync();
    }
    if (fields == null) {
      stdout.write(
          "${ColorsText.blue}Enter Your Form Fields : ${ColorsText.reset}");
      fields = stdin.readLineSync()?.split(',');
    }
    CreatorUtil.createDirectory('$path/features/$featureName/forms');
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/forms/${formName}_form.dart',
        formSample(formName ?? 'A', fields ?? []));
  }

  static void addAction() {
    stdout.write(
        "${ColorsText.blue}Enter Your Name Feature : ${ColorsText.reset}");
    String? featureName = stdin.readLineSync();
    stdout.write(
        "${ColorsText.blue}Enter Your Name Action : ${ColorsText.reset}");
    String? formName = stdin.readLineSync();
    stdout.write(
        "${ColorsText.blue}Enter Your Action Data : ${ColorsText.reset}");
    List<String>? fields = stdin.readLineSync()?.split(',');
    CreatorUtil.createDirectory('$path/features/$featureName/forms');
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/forms/${formName}_form.dart',
        formSample(formName ?? 'A', fields ?? []));
  }
}
