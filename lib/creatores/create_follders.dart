import 'dart:io';



import '../samples/app_colors_sample.dart';
import '../samples/app_storage_sample.dart';
import 'creator_util.dart';

void main() {
  var path = '${Directory.current.path}/lib';
  CreatorUtil.createDirectory('$path/theme');
  CreatorUtil.createDirectory('$path/core');
  CreatorUtil.createFileWithContent(
      '$path/core/app_storage.dart', appStorageSample());
  CreatorUtil.createFileWithContent(
      '$path/theme/app_colors.dart', appColorsSample());
}
