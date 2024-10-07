import 'extensions.dart';
String pageSample(String featureName) {
  return '''
  import 'package:flutter/material.dart';
  
  class ${featureName.toCapitalized}Page extends StatelessWidget {
    const ${featureName.toCapitalized}Page({super.key});
  
    @override
    Widget build(BuildContext context) {
      return Scaffold();
    }
  }
  
  ''';
}
