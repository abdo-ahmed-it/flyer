import 'dart:io';

import 'package:flyer/core/creator_util.dart';

import '../samples/action_sample.dart';

void addAction({String? featureName, String? actionName, String? path,String method='GET'}) {
   var path = '${Directory.current.path}/lib';

  CreatorUtil.createFileWithContent(
      '$path/features/$featureName/actions/${featureName}_action.dart',
      actionSample(name: actionName,path: path,method: method));
}