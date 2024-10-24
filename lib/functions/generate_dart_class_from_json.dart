import 'dart:io';

import 'package:app_creator/core/colors_text.dart';
import 'package:app_creator/core/creator_util.dart';
import 'package:app_creator/jsonToDart/model_generator.dart';

void generateModelClassFromJson() {
  stdout.write(
      '${ColorsText.blue} Write Class Name and Path (name,path):${ColorsText.reset}');
  String? classNameAndPath = stdin.readLineSync();
  String? className = classNameAndPath?.split(',').first;
  String? classPath = classNameAndPath?.split(',').last;
  stdout
      .write('${ColorsText.blue} Add Response Json Format:${ColorsText.reset}');

  StringBuffer? json = StringBuffer();
  String? line;
  while ((line = stdin.readLineSync()) != null) {
    if (line?.trim() == 'END') {
      break;
    }
    json.writeln(line);
  }
  print(json.toString());
  if (className != null && json.isNotEmpty) {
    ModelGenerator model = ModelGenerator(className);
    try {
      DartCode code = model.generateDartClasses(json.toString());

      var path = '${Directory.current.path}/lib';

      CreatorUtil.createDirectory('$path/$classPath');
      CreatorUtil.createFileWithContent(
          '$path/$classPath/$className.dart', code.code);
    } catch (e) {
      stdout.write(
          "${ColorsText.red}$e\n!DONE${ColorsText.reset}\n");
    }
  }
}
