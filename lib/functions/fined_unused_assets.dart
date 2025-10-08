import 'dart:io';

import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/delete_file.dart';

void fiendUnusedAssets() {
  final assetDir = Directory('assets');

  if (!assetDir.existsSync()) {
    print(
        '${ColorsText.yellow}⚠️  Assets directory not found${ColorsText.reset}\n');
    return;
  }

  print('${ColorsText.blue}🔍 Scanning assets directory...${ColorsText.reset}');
  final assetFiles = assetDir
      .listSync(recursive: true)
      .whereType<File>()
      .map((file) => file.path)
      .toList();

  print(
      '${ColorsText.blue}🔍 Checking asset usage in Dart files...${ColorsText.reset}\n');
  final usedAssets = <String>{};
  final dartFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));

  for (var file in dartFiles) {
    final content = file.readAsStringSync();
    for (var asset in assetFiles) {
      if (content.contains(asset.split('/').last)) {
        usedAssets.add(asset);
      }
    }
  }

  final unusedAssets = assetFiles.toSet().difference(usedAssets);

  if (unusedAssets.isNotEmpty) {
    print('${ColorsText.yellow}⚠️  Unused assets found:${ColorsText.reset}');
    for (var asset in unusedAssets) {
      print('${ColorsText.gray}  - $asset${ColorsText.reset}');
    }
    print('');
    deleteFiles(unusedAssets.toList());
  } else {
    print('${ColorsText.green}✓ All assets are used.${ColorsText.reset}\n');
  }
}
