import 'dart:io';

import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/delete_file.dart';

void findUnusedFiles() {
  Directory libDirectory = Directory('lib');

  if (!libDirectory.existsSync()) {
    print('${ColorsText.red}✗ lib directory not found!${ColorsText.reset}');
    return;
  }

  print('${ColorsText.blue}🔍 Scanning Dart files...${ColorsText.reset}');

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

  print('${ColorsText.blue}🔍 Checking file usage...${ColorsText.reset}\n');

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
    print(
        '${ColorsText.yellow}⚠️  Unused files found (${unusedFiles.length}):${ColorsText.reset}');
    for (var filePath in unusedFiles) {
      print('${ColorsText.gray}  - $filePath${ColorsText.reset}');
    }
    print('');
    deleteFiles(unusedFiles);
  } else {
    print('${ColorsText.green}✓ All files are used.${ColorsText.reset}\n');
  }
}
