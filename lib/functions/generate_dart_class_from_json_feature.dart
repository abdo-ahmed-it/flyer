import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/core/creator_util.dart';
import 'package:flyer/jsonToDart/model_generator.dart';

void generateModelClassFromJsonInFeature() {
  stdout.write(
      '${ColorsText.blue} Write Class Name and feature (name,feature):${ColorsText.reset}');
  String? classNameAndPath = stdin.readLineSync();
  String? className = classNameAndPath?.split(',').first;
  String? featureName = classNameAndPath?.split(',').last;
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
  debugPrint(json.toString());
  if (className != null && json.isNotEmpty) {
    ModelGenerator model = ModelGenerator(className);
    try {
      DartCode code = model.generateDartClasses(json.toString());

      var lib = '${Directory.current.path}/lib';

      CreatorUtil.createDirectory('$lib/$featureName');
      CreatorUtil.createFileWithContent(
          '$lib/features/$featureName/actions/$className.dart', code.code);
    } catch (e) {
      stdout.write("${ColorsText.red}$e\n!DONE${ColorsText.reset}\n");
    }
  }
}
