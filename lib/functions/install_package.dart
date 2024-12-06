import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/colors_text.dart';

Future<void> installPackage(String name) async {
  var response =
      await http.get(Uri.parse('https://pub.dev/api/packages/$name'));
  if (response.statusCode == HttpStatus.notFound) {
    print(response.body);
  } else if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    String latestVersion = data['latest']['version'];
    final pubspec = File('pubspec.yaml').readAsStringSync();
    if (!pubspec.contains(name)) {
      final updatedPubspec = pubspec.replaceFirst(
        'dependencies:\n',
        "dependencies:\n  $name: ^$latestVersion\n",
      );
      File('pubspec.yaml').writeAsStringSync(updatedPubspec);
      print(
          '${ColorsText.green}$name@^$latestVersion installed successfully!${ColorsText.reset}');
    }
    // String pubspecContent = await CreatorUtil.readFileContent('pubspec.yaml');
    // var yamlMap = loadYaml(pubspecContent);
    // var _dependencies = yamlMap['dependencies'] as Map;
    // Map<String, dynamic> dependencies = Map.from(_dependencies);
    // if (dependencies.containsKey(name)) {
    //   dependencies[name] = latestVersion;
    // } else {
    //   dependencies[name] = latestVersion;
    // }
    // CreatorUtil.editFileContent('pubspec.yaml', pubspecContent,
    //     canFormated: false);
  }
}
