import 'dart:io';

class CreatorUtil {
  // Function to create Directory
  static void createDirectory(String path) {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      print('Created directory: $path');
    }
  }

// Function to create a file with content
  static void createFileWithContent(String path, String content) {
    final file = File(path);
    if (!file.existsSync()) {
      file.writeAsStringSync(content);
      print('Created file: $path');
    }
  }

  // Function to read file content
  static Future<String> readFileContent(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      final content = await file.readAsString();
      print('Content File: $content');
      return content;
    }
    return 'File not exists';
  }

  // Function to edit file content
  static void editFileContent(String path, String newContent) {
    final file = File(path);
    if (file.existsSync()) {
      file.writeAsStringSync(newContent);
      print('Updated content written to file $path.');
    } else {
      print('File does not exist: $path');
    }
  }
}
