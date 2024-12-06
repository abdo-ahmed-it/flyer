import 'dart:io';

import '../core/colors_text.dart';

Future<void> runPubGet() async {
  try {
    print('${ColorsText.gray}Running pub get... ${ColorsText.reset}');
    final result = await Process.run(
      'dart',
      ['pub', 'get'],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      print('Pub get completed successfully.');
      print(result.stdout); // مخرجات الأمر
    } else {
      print('Error running pub get:');
      print(result.stderr); // رسائل الخطأ
    }
  } catch (e) {
    print('Failed to run pub get: $e');
  }
}
