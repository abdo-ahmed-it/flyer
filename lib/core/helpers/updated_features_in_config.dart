import 'dart:io';

import 'package:flyer/core/app_helper.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/creator_util.dart';

void updateFeaturesInConfigFile(String featureName) {
  final file = File('lib/config/app_config.dart');
  if (!file.existsSync()) {
    print(
        '${ColorsText.red}✗ app_config.dart file not found${ColorsText.reset}');
    return;
  }

  String content = file.readAsStringSync();
  content = '''import '../features/$featureName/${featureName}_feature.dart';
$content''';

  featureName = '${AppHelper.toClassName(featureName)}Feature()';

  // Updated regex to handle both single-line and multi-line format
  final featureRegex = RegExp(
    r'AppFeatures\.config\(\s*features:\s*\[(.*?)\]\s*[,\)]',
    dotAll: true,
  );
  final match = featureRegex.firstMatch(content);

  if (match != null) {
    final featuresList = match.group(1);
    if (featuresList != null) {
      var features = featuresList
          .split(',')
          .map((f) => f.trim())
          .where((f) => f.isNotEmpty)
          .toList();

      // Check if the feature already exists
      if (!features.contains(featureName)) {
        features.add(featureName);
      } else {
        print(
            '${ColorsText.yellow}⚠ Feature already exists in config${ColorsText.reset}');
        return;
      }

      // Create the updated feature string (multi-line format)
      final updatedFeatures = features.join(', ');

      // Replace the old features list with the new one
      final originalMatch = match.group(0)!;
      final newMatch = originalMatch.replaceFirst(
        RegExp(r'\[(.*?)\]', dotAll: true),
        '[$updatedFeatures]',
      );

      content = content.replaceFirst(originalMatch, newMatch);

      // Write the updated content back to the file
      CreatorUtil.editFileContent(file.path, content, canFormated: true);
    } else {
      print('${ColorsText.yellow}⚠ No features found${ColorsText.reset}');
    }
  } else {
    print(
        '${ColorsText.red}✗ No AppFeatures.config block found${ColorsText.reset}');
    print(
        '${ColorsText.gray}Make sure your app_config.dart has AppFeatures.config() call${ColorsText.reset}');
  }
}
