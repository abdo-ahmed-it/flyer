import 'dart:io';

import '../core/colors_text.dart';

Future<void> runPubGet() async {
  try {
    print('${ColorsText.blue}Running pub get...${ColorsText.reset}');
    final result = await Process.run(
      'dart',
      ['pub', 'get'],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      print(
          '${ColorsText.green}✓ Pub get completed successfully${ColorsText.reset}');
      if (result.stdout.toString().isNotEmpty) {
        print('${ColorsText.gray}${result.stdout}${ColorsText.reset}');
      }
    } else {
      print('${ColorsText.red}✗ Error running pub get:${ColorsText.reset}');
      print('${ColorsText.gray}${result.stderr}${ColorsText.reset}');
    }
  } catch (e) {
    print('${ColorsText.red}✗ Failed to run pub get: $e${ColorsText.reset}');
  }
}
