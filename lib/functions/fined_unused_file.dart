import 'dart:io';

void findUnusedFiles() {
  Directory libDirectory = Directory('lib');

  if (!libDirectory.existsSync()) {
    print('lib directory not found!');
    return;
  }

  List<String> unusedFiles = [];

  List<File> dartFiles = [];
  libDirectory.listSync(recursive: true).forEach((fileSystemEntity) {
    if (fileSystemEntity is File && fileSystemEntity.path.endsWith('.dart')) {
      dartFiles.add(fileSystemEntity);
    }
  });

  dartFiles.forEach((file) {
    bool isUsed = false;

    dartFiles.forEach((otherFile) {
      if (otherFile != file) {
        String content = otherFile.readAsStringSync();
        if (content.contains(file.path.split('/').last)) {
          isUsed = true;
        }
      }
    });

    if (!isUsed) {
      unusedFiles.add(file.path);
    }
  });

  if (unusedFiles.isNotEmpty) {
    print('Unused files (${unusedFiles.length}):');
    unusedFiles.forEach((filePath) {
      print('- $filePath');
    });
  } else {
    print('All files are used.');
  }
}
