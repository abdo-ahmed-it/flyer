import 'dart:io';
import 'package:yaml/yaml.dart';

void fiendUnusedPackages() {
  var pubspecPath = 'pubspec.yaml';

  File pubspecFile = File(pubspecPath);
  if (!pubspecFile.existsSync()) {
    print('pubspec.yaml not found!');
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
    packages.keys.forEach((package) {
      if (excludedPackages.contains(package)) {
        return;
      }

      bool isUsed = false;
      Directory directory = Directory('lib');

      if (directory.existsSync()) {
        directory.listSync(recursive: true).forEach((fileSystemEntity) {
          if (fileSystemEntity is File && fileSystemEntity.path.endsWith('.dart')) {
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
    });
  }

  print('Checking dependencies...');
  checkUnusedPackages(dependencies);

  print('Checking dev_dependencies...');
  checkUnusedPackages(devDependencies);

  if (unusedPackages.isNotEmpty) {
    print('Unused packages:');
    unusedPackages.forEach((package) {
      print('- $package');
    });
  } else {
    print('All packages are used.');
  }
}

