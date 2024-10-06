import 'dart:io';

import '../samples/cubit_samples.dart';
import '../samples/feature_sample.dart';
import '../samples/page_sample.dart';
import '../samples/state_samples.dart';
import 'creator_util.dart';


void main() {
  stdout.write("Enter Your Name Feature : ");
  String? featureName = stdin.readLineSync();
  var path = '${Directory.current.path}/lib';
  CreatorUtil.createDirectory('$path/features');
  CreatorUtil.createDirectory('$path/features/$featureName');
  CreatorUtil.createDirectory('$path/features/$featureName/actions');
  CreatorUtil.createDirectory('$path/features/$featureName/bloc');
  CreatorUtil.createFileWithContent(
      '$path/features/$featureName/${featureName}_feature.dart',
      featureSample(featureName!));
  CreatorUtil.createFileWithContent('$path/features/$featureName/${featureName}_page.dart',
      pageSample(featureName));
  CreatorUtil.createFileWithContent(
      '$path/features/$featureName/bloc/${featureName}_state.dart',
      stateSample(featureName));
  CreatorUtil.createFileWithContent(
      '$path/features/$featureName/bloc/${featureName}_bloc.dart',
      cubitSample(featureName));
}








