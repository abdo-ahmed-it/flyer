import 'dart:io';

import 'package:flyer/core/colors_text.dart';

void deleteFiles(List<String> paths) {
  stdout.write(
      '${ColorsText.blue}Do you want to delete these files? (y/n): ${ColorsText.reset}');
  String? answer = stdin.readLineSync();
  if (answer != null &&
      (answer == 'y' ||
          answer == 'Y' ||
          answer == 'Yes' ||
          answer == 'yes' ||
          answer == 'YES')) {
    print('');
    for (var path in paths) {
      _deleteFile(path);
    }
    print(
        '\n${ColorsText.green}✓ Files deleted successfully${ColorsText.reset}\n');
  } else {
    print('${ColorsText.yellow}Deletion cancelled${ColorsText.reset}\n');
  }
}

void _deleteFile(String filePath) {
  final file = File(filePath);

  // Check if the file exists before attempting to delete it
  if (file.existsSync()) {
    try {
      file.deleteSync();
      print(
          '${ColorsText.green}  ✓${ColorsText.reset} Deleted: ${ColorsText.gray}$filePath${ColorsText.reset}');
    } catch (e) {
      print('${ColorsText.red}  ✗${ColorsText.reset} Error deleting file: $e');
    }
  } else {
    print(
        '${ColorsText.yellow}  ⚠${ColorsText.reset} File not found: $filePath');
  }
}
