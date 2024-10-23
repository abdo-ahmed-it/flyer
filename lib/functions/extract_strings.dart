import 'dart:io';

import 'package:app_creator/core/colors_text.dart';


void extractArabicText() {
  Directory libDirectory = Directory('lib');

  if (!libDirectory.existsSync()) {
    print('lib directory not found!');
    return;
  }

  List<String> arabicTextsForTranslation = [];

  libDirectory.listSync(recursive: true).forEach((fileSystemEntity) {
    if (fileSystemEntity is File && fileSystemEntity.path.endsWith('.dart')) {
      String content = fileSystemEntity.readAsStringSync();

      RegExp regex = RegExp(
          r'''["\']([^"\']*[\u0600-\u06FF]+[^"\']*)["\']''' '',
          dotAll: true);
      Iterable<RegExpMatch> matches = regex.allMatches(content);

      for (var match in matches) {
        var extractedText = match.group(0);

        if (extractedText != null && extractedText.isNotEmpty) {
          arabicTextsForTranslation.add(extractedText);
          print('path ${fileSystemEntity.path}');
        }
      }
    }
  });

  if (arabicTextsForTranslation.isNotEmpty) {
    print('Extracted Arabic texts for translation:');
    arabicTextsForTranslation.forEach((text) {
      print(text);
    });
  } else {
    print('No Arabic texts found for translation.');
  }
}

void extractTextFromTextWidgets() {
  Directory libDirectory = Directory('lib');

  if (!libDirectory.existsSync()) {
    print('lib directory not found!');
    return;
  }

  List<Data> texts = [];

  libDirectory.listSync(recursive: true).forEach((fileSystemEntity) {
    if (fileSystemEntity is File && fileSystemEntity.path.endsWith('.dart')) {
      String content = fileSystemEntity.readAsStringSync();
      String importStatement = "import 'package:example/core/app_extinsions.dart';";
      if (!content.contains(importStatement)) {
        content = '$importStatement\n$content';
      }

      RegExp textRegex = RegExp(
          r'''Text\s*\(\s*["\']([^"\']*)["\']|title:\s*["\']([^"\']*)["\']|label:\s*["\']([^"\']*)["\']|textLabel:\s*["\']([^"\']*)["\']|hint:\s*["\']([^"\']*)["\']''',
          dotAll: true);
      Iterable<RegExpMatch> textMatches = textRegex.allMatches(content);

      bool hasReplacements = false;

      for (var match in textMatches) {
        for (int i = 1; i <= 5; i++) {
          if (match.group(i) != null && match.group(i)!.isNotEmpty) {
            String extractedText = match.group(i)!;

            texts.add(Data(
              text: extractedText,
              path: fileSystemEntity.path.split('/').last,
            ));
            String key = _generateKey(extractedText);
            String replacement = 'context.loc.$key';

            if (content.contains('"$extractedText"')) {
              content = content.replaceFirst('"$extractedText"', replacement);
              hasReplacements = true;
            } else if (content.contains("'$extractedText'")) {
              content = content.replaceFirst("'$extractedText'", replacement);
              hasReplacements = true;
            }
          }
        }
      }
      if (hasReplacements) {
        fileSystemEntity.writeAsStringSync(content);
      }
    }
  });

  if (texts.isNotEmpty) {
    List unDuplicatedTexts = texts.toSet().toList();
    stdout.write(
        '${ColorsText.orange} Extracted texts from Text widgets and titles: ${ColorsText.reset}\n');

    for (int i = 0; i < texts.length; i++) {
      stdout.write(
          '${ColorsText.yellow}${texts[i].text} ${ColorsText.reset}-${texts[i].path}\n');
    }
    stdout.write(
        '${ColorsText.orange} Extracted texts JSON Format: ${ColorsText.reset}\n');

    for (int i = 0; i < unDuplicatedTexts.length; i++) {
      print(
          '''"${_generateKey(unDuplicatedTexts[i].text.toString())}":"${unDuplicatedTexts[i].text}",''');
    }
  } else {
    print('No texts found');
  }
}

String _generateKey(String text) {
  return text.toLowerCase().trimLeft().trimRight().replaceAll(' ', '_');
}

class Data {
  String text;
  String path;

  Data({required this.text, required this.path});
}

