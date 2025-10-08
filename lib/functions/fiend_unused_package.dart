import 'dart:io';

import 'package:flyer/core/colors_text.dart';
import 'package:yaml/yaml.dart';

void fiendUnusedPackages() {
  var pubspecPath = 'pubspec.yaml';

  File pubspecFile = File(pubspecPath);
  if (!pubspecFile.existsSync()) {
    print('${ColorsText.red}✗ pubspec.yaml not found!${ColorsText.reset}');
    return;
  }

  String pubspecContent = pubspecFile.readAsStringSync();

  var yamlMap = loadYaml(pubspecContent);

  var dependencies = yamlMap['dependencies'] as Map;
  var devDependencies = yamlMap['dev_dependencies'] as Map;

  List<String> unusedPackages = [];

  List<String> excludedPackages = [
    'cupertino_icons',
    'flutter_test',
    'flutter_lints'
  ];

  void checkUnusedPackages(Map packages) {
    for (var package in packages.keys) {
      if (excludedPackages.contains(package)) {
        continue;
      }

      bool isUsed = false;
      Directory directory = Directory('lib');

      if (directory.existsSync()) {
        directory.listSync(recursive: true).forEach((fileSystemEntity) {
          if (fileSystemEntity is File &&
              fileSystemEntity.path.endsWith('.dart')) {
            String content = fileSystemEntity.readAsStringSync();

            if (content.contains("import 'package:$package")) {
              isUsed = true;
            }
          }
        });
      }

      if (!isUsed) {
        unusedPackages.add(package);
      }
    }
  }

  print('${ColorsText.blue}🔍 Checking dependencies...${ColorsText.reset}');
  checkUnusedPackages(dependencies);

  print(
      '${ColorsText.blue}🔍 Checking dev_dependencies...${ColorsText.reset}\n');
  checkUnusedPackages(devDependencies);

  if (unusedPackages.isNotEmpty) {
    print('${ColorsText.yellow}⚠️  Unused packages found:${ColorsText.reset}');
    for (var package in unusedPackages) {
      print('${ColorsText.gray}  - $package${ColorsText.reset}');
    }
    print('');
  } else {
    print('${ColorsText.green}✓ All packages are used.${ColorsText.reset}\n');
  }
}
