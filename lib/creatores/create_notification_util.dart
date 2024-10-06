import 'dart:io';


import '../samples/utils/notification_util_sample.dart';
import 'creator_util.dart';


void main(){
  var path = '${Directory.current.path}/lib';
  CreatorUtil.createDirectory('$path/app');
  CreatorUtil.createDirectory('$path/app/utils');
  CreatorUtil.createFileWithContent('$path/app/utils/notification_util.dart',notificationsUtilSample());
}