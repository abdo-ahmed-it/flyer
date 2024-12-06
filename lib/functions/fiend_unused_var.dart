import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flyer/core/creator_util.dart';
void findUnusedVariablesInApp(){
  Directory libDirectory = Directory('lib');

  if (!libDirectory.existsSync()) {
    print('lib directory not found!');
    return;
  }

  // List<File> dartFiles = [];
  libDirectory.listSync(recursive: true).forEach((file) {
    if (file is File && file.path.endsWith('.dart')) {
      // dartFiles.add(fileSystemEntity);
      findUnusedVariablesInFile(file.path);
    }
  });
}

void findUnusedVariablesInFile(String path)async {
  String code= await CreatorUtil.readFileContent(path);
  var parseResult = parseString(content: code);
  var compilationUnit = parseResult.unit;

  for (var declaration in compilationUnit.declarations) {
    if (declaration is TopLevelVariableDeclaration) {
      for (var variable in declaration.variables.variables) {
        print('Found top-level variable: ${variable.name}');
      }
    }
    else if (declaration is ClassDeclaration) {
      for (var member in declaration.members) {
        if (member is FieldDeclaration) {
          for (var variable in member.fields.variables) {
            print('Found class-level variable: ${variable.name}');
          }
        }
      }
    }
  }
}
