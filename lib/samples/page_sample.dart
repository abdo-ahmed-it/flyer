import 'package:app_creator/core/app_helper.dart';

import '../core/extensions.dart';
String pageSample(String featureName) {
  return '''
  import 'package:flutter/material.dart';
  
  class ${AppHelper.toClassName(featureName)}Page extends StatelessWidget {
    const ${AppHelper.toClassName(featureName)}Page({super.key});
  
    @override
    Widget build(BuildContext context) {
      return Scaffold();
    }
  }
  
  ''';
}
