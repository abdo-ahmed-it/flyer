import 'dart:io';

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

  List<String> texts = [];

  libDirectory.listSync(recursive: true).forEach((fileSystemEntity) {
    if (fileSystemEntity is File && fileSystemEntity.path.endsWith('.dart')) {
      String content = fileSystemEntity.readAsStringSync();

      RegExp textRegex = RegExp(
          r'''Text\s*\(\s*["\']([^"\']*)["\']|title:\s*["\']([^"\']*)["\']''',
          dotAll: true);
      Iterable<RegExpMatch> textMatches = textRegex.allMatches(content);

      for (var match in textMatches) {
        if (match.group(1) != null && match.group(1)!.isNotEmpty) {
          texts.add(match.group(1)!);
        }
        if (match.group(2) != null && match.group(2)!.isNotEmpty) {
          texts.add(match.group(2)!);
        }
      }
    }
  });

  if (texts.isNotEmpty) {
    print('Extracted texts from Text widgets and titles:');
    texts.forEach((text) {
      print(text);
    });
  } else {
    print('No texts found in Text widgets or titles.');
  }
}
