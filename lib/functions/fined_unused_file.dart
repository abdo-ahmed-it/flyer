import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flyer/functions/delete_file.dart';

void findUnusedFiles() {
  Directory libDirectory = Directory('lib');

  if (!libDirectory.existsSync()) {
    print('lib directory not found!');
    return;
  }

  List<String> unusedFiles = [];
  List<String> excludedFiles = [
    'main.dart',
    'main_dev.dart',
    'main_test.dart',
    'main_prod.dart',
    'main_staging.dart',
    'main_stage.dart',
  ];

  List<File> dartFiles = [];
  libDirectory.listSync(recursive: true).forEach((fileSystemEntity) {
    if (fileSystemEntity is File && fileSystemEntity.path.endsWith('.dart')) {
      dartFiles.add(fileSystemEntity);
    }
  });

  for (var file in dartFiles) {
    bool isUsed = false;

    for (var otherFile in dartFiles) {
      if (otherFile != file) {
        String content = otherFile.readAsStringSync();
        if (content.contains(file.path.split('/').last)) {
          isUsed = true;
        }
      }
    }

    if (!isUsed && !excludedFiles.contains(file.path.split('/').last)) {
      unusedFiles.add(file.path);
    }
  }

  if (unusedFiles.isNotEmpty) {
    print('Unused files (${unusedFiles.length}):');
    for (var filePath in unusedFiles) {
      print('- $filePath');
    }
    deleteFiles(unusedFiles);
  } else {
    print('All files are used.');
  }
}
