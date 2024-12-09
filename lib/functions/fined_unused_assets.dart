import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flyer/functions/delete_file.dart';

void fiendUnusedAssets() {
  final assetDir = Directory('assets');
  final assetFiles = assetDir
      .listSync(recursive: true)
      .whereType<File>()
      .map((file) => file.path)
      .toList();

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
  print('Unused assets:');
  for (var asset in unusedAssets) {
    print(asset);
  }
  deleteFiles(unusedAssets.toList());
}
