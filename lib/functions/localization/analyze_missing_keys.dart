import 'dart:io';
import 'package:flyer/core/colors_text.dart';

/// Analyzes the project using dart analyze and extracts missing localization keys
Future<Set<String>> analyzeMissingKeys({required bool verbose}) async {
  final missingKeys = <String>{};

  try {
    // Run dart analyze with machine format
    final result = await Process.run(
      'dart',
      ['analyze', '--format=machine'],
      workingDirectory: Directory.current.path,
    );

    if (result.exitCode != 0 && result.stdout.toString().isNotEmpty) {
      // Parse the output line by line
      final lines = result.stdout.toString().split('\n');

      for (var line in lines) {
        if (line.isEmpty) continue;

        // Look for patterns indicating missing localization keys
        // Pattern 1: The getter 'keyName' isn't defined for the type 'AppLocalizations'
        // Pattern 2: Undefined name 'keyName' in context.loc.keyName

        final patterns = [
          RegExp(r"The getter '(\w+)' isn't defined for (?:the )?type 'AppLocalizations'"),
          RegExp(r"The getter '(\w+)' isn't defined for (?:the )?class 'AppLocalizations'"),
          RegExp(r"Undefined name '(\w+)'.*\.loc\."),
        ];

        for (var pattern in patterns) {
          final match = pattern.firstMatch(line);
          if (match != null && match.groupCount > 0) {
            final keyName = match.group(1);
            if (keyName != null && keyName.isNotEmpty) {
              missingKeys.add(keyName);

              if (verbose) {
                print('${ColorsText.yellow}🔍 Found missing key: "$keyName"${ColorsText.reset}');
              }
            }
          }
        }
      }
    }

    // Also try flutter analyze for more comprehensive results
    try {
      final flutterResult = await Process.run(
        'flutter',
        ['analyze', '--no-pub'],
        workingDirectory: Directory.current.path,
      );

      if (flutterResult.exitCode != 0 && flutterResult.stdout.toString().isNotEmpty) {
        final output = flutterResult.stdout.toString();

        // Look for getter errors in flutter analyze output
        final getterPattern = RegExp(
          r"The getter '(\w+)' isn't defined for (?:the )?(?:type|class) 'AppLocalizations'",
          multiLine: true,
        );

        for (var match in getterPattern.allMatches(output)) {
          final keyName = match.group(1);
          if (keyName != null && keyName.isNotEmpty) {
            if (missingKeys.add(keyName) && verbose) {
              print('${ColorsText.yellow}🔍 Found missing key: "$keyName"${ColorsText.reset}');
            }
          }
        }
      }
    } catch (e) {
      // Flutter analyze failed, continue with dart analyze results
      if (verbose) {
        print('${ColorsText.gray}Note: flutter analyze not available, using dart analyze only${ColorsText.reset}');
      }
    }

  } catch (e) {
    print('${ColorsText.red}✗ Error running analysis: $e${ColorsText.reset}');
  }

  return missingKeys;
}