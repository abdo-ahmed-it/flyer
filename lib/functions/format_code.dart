import 'dart:io';

import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/creator_util.dart';
import 'package:dart_style/dart_style.dart';

void formatCode() async {
  DartFormatter formatter =
      DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);
  Directory lib = Directory('lib');

  if (!lib.existsSync()) {
    print('${ColorsText.red}✗ lib directory not found!${ColorsText.reset}');
    return;
  }

  print('${ColorsText.blue}🔍 Scanning Dart files...${ColorsText.reset}');
  int fileCount = 0;

  lib.listSync(recursive: true).forEach((file) async {
    if (file is File && file.path.endsWith('.dart')) {
      String? code = await CreatorUtil.readFileContent(file.path);
      if (code.isNotEmpty) {
        String formattedCode = formatter.format(code);
        CreatorUtil.editFileContent(file.path, formattedCode, showLog: false);
        fileCount++;
      }
    }
  });

  print(
      '${ColorsText.green}✓ Successfully formatted $fileCount Dart files${ColorsText.reset}\n');
}
