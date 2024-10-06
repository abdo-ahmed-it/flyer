import 'dart:io';

import '../samples/app_theme_sample.dart';
import 'creator_util.dart';

void main(){
  var path='${Directory.current.path}/lib';
  CreatorUtil.createFileWithContent('$path/theme/app_theme.dart', appThemeSample());
}