import 'dart:io';

import 'package:app_creator/samples/main_sample.dart';


import 'creator_util.dart';

void main(){
  var path='${Directory.current.path}/lib';
  CreatorUtil.editFileContent('$path/main.dart', mainSample());
}