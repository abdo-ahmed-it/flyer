import 'dart:io';

import 'package:app_creator/core/colors_text.dart';
import 'package:dart_style/dart_style.dart';

class CreatorUtil {
  // Function to create Directory
  static void createDirectory(String path) {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      stdout.write(
          '${ColorsText.yellow}Success Created directory: $path${ColorsText.reset}\n');
    }
  }

// Function to create a file with content
  static void createFileWithContent(String path, String content,
      {bool canFormated = true}) {
    final file = File(path);
    if (!file.existsSync()) {
      file.writeAsStringSync(
          canFormated ? DartFormatter().format(content) : content);
      stdout.write(
          '${ColorsText.yellow}Success Created File: $path${ColorsText.reset}\n');
    }
  }

  // Function to read file content
  static Future<String> readFileContent(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      final content = await file.readAsString();
      return content;
    }
    stdout.write(
        '${ColorsText.red}File does not exist: $path${ColorsText.reset}\n');
    return 'File not exists';
  }

  // Function to edit file content
  static void editFileContent(String path, String newContent,
      {bool canFormated = true, bool showLog = true}) {
    final file = File(path);
    if (file.existsSync()) {
      file.writeAsStringSync(
          canFormated ? DartFormatter().format(newContent) : newContent);
      if (showLog) {
        stdout.write(
            '${ColorsText.yellow}Updated content written to file: $path${ColorsText.reset}\n');
      }
    } else {
      stdout.write(
          '${ColorsText.red}File does not exist: $path${ColorsText.reset}\n');
    }
  }
}
