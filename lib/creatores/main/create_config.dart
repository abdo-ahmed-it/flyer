import 'dart:io';

import 'package:app_creator/samples/app_config_sample.dart';

import '../creator_util.dart';

void main(){
  var path = '${Directory.current.path}/lib';
  CreatorUtil.createDirectory('$path/config');
  CreatorUtil.createFileWithContent('$path/config/app_config.dart', appConfigSample());
}