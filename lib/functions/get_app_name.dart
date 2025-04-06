import 'dart:io';

import 'package:flyer/core/creator_util.dart';
import 'package:yaml/yaml.dart';

Future<String> getAppName()async{
  String path = Directory.current.path;
  YamlMap yamlMap = loadYaml(await CreatorUtil.readFileContent('$path/pubspec.yaml'));

  return yamlMap['name'];

}