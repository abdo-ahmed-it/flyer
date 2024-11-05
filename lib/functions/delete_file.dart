import 'dart:io';

import 'package:app_creator/core/colors_text.dart';

void deleteFiles(List<String> paths) {
  stdout.write(
      '${ColorsText.blue} Do you need to delete these files?(y,n) ${ColorsText.reset}');
  String? answer = stdin.readLineSync();
  if (answer != null && (answer == 'y' || answer == 'Y' || answer == 'Yes') ||
      answer == 'yes' ||
      answer == 'YES') {
    for (var path in paths) {
      _deleteFile(path);
    }
    stdout.write('${ColorsText.green} Success!');
  }
}

void _deleteFile(String filePath) {
  final file = File(filePath);

  // Check if the file exists before attempting to delete it
  if (file.existsSync()) {
    try {
      file.deleteSync();
      print('File deleted successfully: $filePath');
    } catch (e) {
      print('Error deleting file: $e');
    }
  } else {
    print('File not found: $filePath');
  }
}
