import 'dart:async';
import 'dart:io';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/functions/localization/analyze_missing_keys.dart';
import 'package:flyer/functions/localization/add_keys_to_arb.dart';

/// Watch for Dart file changes and auto-generate missing localization keys
Future<void> watchLocalization({
  required int debounceSeconds,
  required bool verbose,
}) async {
  final libDir = Directory('${Directory.current.path}/lib');

  if (!libDir.existsSync()) {
    print('${ColorsText.red}✗ Error: lib/ directory not found${ColorsText.reset}');
    print('${ColorsText.yellow}Make sure you are in a Flutter project directory${ColorsText.reset}');
    return;
  }

  // Check if l10n directory exists
  final l10nDir = Directory('${Directory.current.path}/lib/l10n');
  if (!l10nDir.existsSync()) {
    print('${ColorsText.red}✗ Error: lib/l10n/ directory not found${ColorsText.reset}');
    print('${ColorsText.yellow}Initialize localization first: ${ColorsText.cyan}flyer make --lang ar,en${ColorsText.reset}');
    return;
  }

  // Print header
  print('${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}');
  print('${ColorsText.cyan}     Auto-Generate Missing Localization Keys${ColorsText.reset}');
  print('${ColorsText.cyan}═══════════════════════════════════════════════════════════${ColorsText.reset}\n');

  Timer? debounceTimer;
  bool isAnalyzing = false;
  DateTime lastModified = DateTime.now();

  // Initial analysis
  final now = DateTime.now();
  final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  print('${ColorsText.blue}🔍 [$timeStr] Running initial analysis...${ColorsText.reset}');
  await _analyzeAndAddKeys(verbose, timeStr);

  // Start watching
  print('${ColorsText.green}✓ Ready! Watching for file changes...${ColorsText.reset}');
  print('${ColorsText.gray}   Debounce: ${debounceSeconds}s | Verbose: ${verbose ? 'ON' : 'OFF'}${ColorsText.reset}');
  print('${ColorsText.gray}   Press Ctrl+C to stop${ColorsText.reset}\n');

  libDir.watch(recursive: true).listen((event) {
    // Only process .dart files (ignore .arb files to prevent loops)
    if (!event.path.endsWith('.dart') || event.path.contains('/l10n/')) {
      return;
    }

    // Only process modify events (file save)
    if (event.type != FileSystemEvent.modify) {
      return;
    }

    // Skip duplicate events (some editors trigger multiple events)
    final file = File(event.path);
    if (file.existsSync()) {
      final modifiedTime = file.lastModifiedSync();
      if (modifiedTime.difference(lastModified).inMilliseconds < 100) {
        return;
      }
      lastModified = modifiedTime;
    }

    // Get filename for logging
    final fileName = event.path.split('/').last;

    if (verbose) {
      print('${ColorsText.gray}📝 File saved: $fileName${ColorsText.reset}');
    }

    // Cancel previous timer
    debounceTimer?.cancel();

    // Start new debounced timer
    debounceTimer = Timer(Duration(seconds: debounceSeconds), () async {
      if (!isAnalyzing) {
        isAnalyzing = true;

        // Get current time
        final now = DateTime.now();
        final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

        if (!verbose) {
          print('${ColorsText.blue}🔍 [$timeStr] Analyzing $fileName...${ColorsText.reset}');
        }

        await _analyzeAndAddKeys(verbose, timeStr);

        isAnalyzing = false;
      }
    });
  });

  // Keep the process running
  await Future.delayed(Duration(days: 365));
}

Future<void> _analyzeAndAddKeys(bool verbose, String timeStr) async {
  try {
    final missingKeys = await analyzeMissingKeys(verbose: verbose);

    if (missingKeys.isEmpty) {
      if (verbose) {
        print('${ColorsText.green}✓ No missing keys found${ColorsText.reset}\n');
      }
      return;
    }

    // Add keys to .arb files
    for (var key in missingKeys) {
      await addKeyToArbFiles(key, verbose: verbose);
    }

    final keysText = missingKeys.length == 1 ? 'key' : 'keys';
    print('${ColorsText.green}✨ Successfully added ${missingKeys.length} $keysText to localization files${ColorsText.reset}');

    // Run flutter gen-l10n to generate localization files
    print('${ColorsText.blue}🔄 [$timeStr] Running flutter gen-l10n...${ColorsText.reset}');

    final result = await Process.run(
      'flutter',
      ['gen-l10n'],
      workingDirectory: Directory.current.path,
    );

    if (result.exitCode == 0) {
      print('${ColorsText.green}✓ Localization files generated successfully${ColorsText.reset}\n');
    } else {
      print('${ColorsText.yellow}⚠ flutter gen-l10n finished with warnings${ColorsText.reset}');
      if (verbose && result.stderr.toString().isNotEmpty) {
        print('${ColorsText.gray}${result.stderr}${ColorsText.reset}');
      }
      print('');
    }

  } catch (e) {
    print('${ColorsText.red}✗ Analysis error: $e${ColorsText.reset}\n');
  }
}