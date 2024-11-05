import 'dart:io';
import 'package:app_creator/core/colors_text.dart';
import 'package:app_creator/samples/utils/notification_util_sample.dart';

import 'core/creator_util.dart';
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
import 'core/extensions.dart';

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

  static void addPage() async {
    stdout.write(
        "${ColorsText.blue}Enter Your Name Feature : ${ColorsText.reset}");
    String? featureName = stdin.readLineSync();
    stdout
        .write("${ColorsText.blue}Enter Your Name Route : ${ColorsText.reset}");
    String? routeName = stdin.readLineSync();

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

  static void addLang() async {
    stdout.write(
        "${ColorsText.blue} Enter Your App Languages as Like This ar,en,... : ${ColorsText.reset}");
    List<String> languages = stdin.readLineSync()?.split(',') ?? ['ar'];

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
        '$path/app/app_feature.dart', featureSample('app'));
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
    createFeature(name: 'splash');
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

  static void addForm() {
    stdout.write(
        "${ColorsText.blue}Enter Your Name Feature : ${ColorsText.reset}");
    String? featureName = stdin.readLineSync();
    stdout
        .write("${ColorsText.blue}Enter Your Name Form : ${ColorsText.reset}");
    String? formName = stdin.readLineSync();
    stdout.write(
        "${ColorsText.blue}Enter Your Form Fields : ${ColorsText.reset}");
    List<String>? fields = stdin.readLineSync()?.split(',');
    CreatorUtil.createDirectory('$path/features/$featureName/forms');
    CreatorUtil.createFileWithContent(
        '$path/features/$featureName/forms/${formName}_form.dart',
        formSample(formName ?? 'A', fields ?? []));
  }
}
