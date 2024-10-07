import 'dart:io';
import '../samples/main_sample.dart';
import 'creator_util.dart';

void main() {
  var path = '${Directory.current.path}/example/lib';
  CreatorUtil.editFileContent('$path/main.dart', mainSample());
}
