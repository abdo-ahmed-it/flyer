import 'dart:io';

import 'package:flutter/material.dart';

import '../core/colors_text.dart';

Future<void> runPubGet() async {
  try {
    debugPrint('${ColorsText.gray}Running pub get... ${ColorsText.reset}');
    final result = await Process.run(
      'dart',
      ['pub', 'get'],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      debugPrint('Pub get completed successfully.');
      debugPrint(result.stdout);
    } else {
      debugPrint('Error running pub get:');
      debugPrint(result.stderr);
    }
  } catch (e) {
    debugPrint('Failed to run pub get: $e');
  }
}
