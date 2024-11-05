import 'dart:io';

import 'package:app_creator/core/colors_text.dart';
import 'package:app_creator/core/creator_util.dart';
import 'package:dart_style/dart_style.dart';

void formatCode() async {
  DartFormatter formatter = DartFormatter();
  Directory lib = Directory('lib');
  // List<String> formatedFile=[];
  lib.listSync(recursive: true).forEach((file) async {
    if (file is File && file.path.endsWith('.dart')) {
      String? code = await CreatorUtil.readFileContent(file.path);
      if (code.isNotEmpty) {
        // formatedFile.add(file.path);
        String formattedCode = formatter.format(code);
        CreatorUtil.editFileContent(file.path, formattedCode, showLog: false);
      }
    }
  });
  stdout.write('${ColorsText.green} Success! ${ColorsText.reset}\n');
}
