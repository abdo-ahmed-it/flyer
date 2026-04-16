import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/colors_text.dart';

Future<void> installPackage(String name) async {
  var response =
      await http.get(Uri.parse('https://pub.dev/api/packages/$name'));
  if (response.statusCode == HttpStatus.notFound) {
    print('${ColorsText.red}  ✗ Package not found: $name${ColorsText.reset}');
    print('${ColorsText.gray}    ${response.body}${ColorsText.reset}');
  } else if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    String latestVersion =
        data['latest']['version'];
    final pubspec = File('pubspec.yaml').readAsStringSync();
    if (!pubspec.contains(name)) {
      final updatedPubspec = pubspec.replaceFirst(
        'dependencies:\n',
        "dependencies:\n  $name: ^$latestVersion\n",
      );
      File('pubspec.yaml').writeAsStringSync(updatedPubspec);
      print(
          '${ColorsText.green}  ✓${ColorsText.reset} Installed: ${ColorsText.cyan}$name${ColorsText.reset} ${ColorsText.gray}^$latestVersion${ColorsText.reset}');
    } else {
      print(
          '${ColorsText.gray}  - Already installed: $name${ColorsText.reset}');
    }
  }
}

Future<void> installPackageAsOverride(String name) async {
  var response =
      await http.get(Uri.parse('https://pub.dev/api/packages/$name'));
  if (response.statusCode == HttpStatus.notFound) {
    print('${ColorsText.red}  ✗ Package not found: $name${ColorsText.reset}');
    print('${ColorsText.gray}    ${response.body}${ColorsText.reset}');
  } else if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    String latestVersion =
        data['latest']['version'];
    final pubspec = File('pubspec.yaml').readAsStringSync();
    if (!pubspec.contains(name)) {
      String updatedPubspec;
      if (pubspec.contains('dependency_overrides:')) {
        // Add to existing dependency_overrides section
        updatedPubspec = pubspec.replaceFirst(
          'dependency_overrides:\n',
          "dependency_overrides:\n  $name: ^$latestVersion\n",
        );
      } else {
        // Create new dependency_overrides section
        updatedPubspec = pubspec.replaceFirst(
          'dev_dependencies:',
          "dependency_overrides:\n  $name: ^$latestVersion\ndev_dependencies:",
        );
      }
      File('pubspec.yaml').writeAsStringSync(updatedPubspec);
      print(
          '${ColorsText.green}  ✓${ColorsText.reset} Installed override: ${ColorsText.cyan}$name${ColorsText.reset} ${ColorsText.gray}^$latestVersion${ColorsText.reset}');
    } else {
      print(
          '${ColorsText.gray}  - Already installed: $name${ColorsText.reset}');
    }
  }
}
