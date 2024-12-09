import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flyer/core/app_helper.dart';
import 'package:flyer/core/creator_util.dart';

void updateFeaturesInConfigFile(String featureName) {
  final file = File('lib/config/app_config.dart');
  if (!file.existsSync()) {
    print('File not found');
    return;
  }

  String content = file.readAsStringSync();
  content = '''
  import '../features/$featureName/${featureName}_feature.dart';$content
''';
  featureName = '${AppHelper.toClassName(featureName)}Feature()';
  final featureRegex = RegExp(
    r'AppFeatures\.config\(\s*features:\s*\[(.*?)\]\s*\)',
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
        print('Feature already exists.');
        return;
      }

      // Create the updated feature string
      final updatedFeatures = features.join(', ');

      // Replace the old features list with the new one
      content = content.replaceFirst(
        featureRegex,
        'AppFeatures.config(features: [$updatedFeatures])',
      );

      // Write the updated content back to the file
      CreatorUtil.editFileContent(file.path, content);
      print('Feature added successfully.');
    } else {
      print('No features found.');
    }
  } else {
    print('No AppFeatures.config block found.');
  }
}
