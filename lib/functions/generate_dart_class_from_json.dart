import 'dart:io';

import 'package:flyer/core/app_helper.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/creator_util.dart';
import 'package:flyer/jsonToDart/model_generator.dart';

void generateModelClassFromJson(
    {required String className, required String json, String? path}) {
  try {
    // final className = argResults?['class-name'] as String?;
    // final jsonInput = (argResults?['json'] as String?);
    final inputPath = path ?? 'app/models';

    // if (className == null || jsonInput == null) {
    //   print(
    //       '${ColorsText.red}Error: Missing required options for model generation.${ColorsText.reset}');
    //   // print(parser.usage);
    //   return;
    // }

    ModelGenerator model = ModelGenerator(className);
    DartCode code = model.generateDartClasses(json);

    final basePath = '${Directory.current.path}/lib';
    final filePath = '$basePath/$inputPath';
    CreatorUtil.createDirectory(filePath);
    CreatorUtil.createFileWithContent(
        '$filePath/${AppHelper.toFileName(className)}.dart', code.code);

    print(
        '${ColorsText.green}Model class generated successfully at $filePath!${ColorsText.reset}');
  } catch (e) {
    print("${ColorsText.red}Error: $e${ColorsText.reset}");
  }
}
