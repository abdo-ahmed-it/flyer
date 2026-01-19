import 'dart:convert';
import 'dart:io';
import 'package:flyer/core/colors_text.dart';

/// Adds a missing key to all .arb files in lib/l10n/
Future<void> addKeyToArbFiles(String key, {required bool verbose}) async {
  final l10nDir = Directory('${Directory.current.path}/lib/l10n');

  if (!l10nDir.existsSync()) {
    print('${ColorsText.red}✗ lib/l10n/ directory not found${ColorsText.reset}');
    return;
  }

  // Get all .arb files
  final arbFiles = l10nDir
      .listSync()
      .where((entity) => entity is File && entity.path.endsWith('.arb'))
      .cast<File>()
      .toList();

  if (arbFiles.isEmpty) {
    print('${ColorsText.red}✗ No .arb files found in lib/l10n/${ColorsText.reset}');
    return;
  }

  for (var arbFile in arbFiles) {
    try {
      // Read existing content
      final content = arbFile.readAsStringSync();
      Map<String, dynamic> arbData;

      if (content.trim().isEmpty) {
        arbData = {};
      } else {
        arbData = jsonDecode(content) as Map<String, dynamic>;
      }

      // Check if key already exists
      if (arbData.containsKey(key)) {
        if (verbose) {
          print('${ColorsText.gray}  → Key "$key" already exists in ${_getFileName(arbFile.path)}${ColorsText.reset}');
        }
        continue;
      }

      // Extract language code from filename (e.g., app_ar.arb -> ar)
      final fileName = arbFile.path.split('/').last;
      final langMatch = RegExp(r'app_(\w+)\.arb').firstMatch(fileName);
      final langCode = langMatch?.group(1) ?? 'en';

      // Add the new key with a default value
      final defaultValue = _getDefaultValueForLanguage(key, langCode);
      arbData[key] = defaultValue;

      // Write back with pretty formatting
      final encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(arbData);
      arbFile.writeAsStringSync(prettyJson);

      if (verbose) {
        print('${ColorsText.green}  ✓ Added "$key" = "$defaultValue" → ${_getFileName(arbFile.path)}${ColorsText.reset}');
      } else {
        print('${ColorsText.green}  ✓ $key → ${_getFileName(arbFile.path)}${ColorsText.reset}');
      }

    } catch (e) {
      print('${ColorsText.red}✗ Error updating ${_getFileName(arbFile.path)}: $e${ColorsText.reset}');
    }
  }
}

/// Get filename from full path
String _getFileName(String path) {
  return path.split('/').last;
}

/// Generate default value based on language and key name
String _getDefaultValueForLanguage(String key, String langCode) {
  // Convert camelCase or snake_case to Title Case
  final words = key
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => ' ${match.group(1)}',
      )
      .replaceAll('_', ' ')
      .trim()
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');

  // Language-specific prefixes for clarity
  switch (langCode) {
    case 'ar':
      return 'ترجمة_$words'; // Arabic: "Translation_"
    case 'en':
      return words;
    case 'fr':
      return 'Trad_$words'; // French: "Traduction_"
    case 'es':
      return 'Trad_$words'; // Spanish: "Traducción_"
    case 'de':
      return 'Über_$words'; // German: "Übersetzung_"
    default:
      return '$langCode:$words';
  }
}
