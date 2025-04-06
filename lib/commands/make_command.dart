import 'package:args/command_runner.dart';
import 'package:flyer/creatores.dart';
import 'package:flyer/functions/generate_dart_class_from_json.dart';

class MakeCommand extends Command {
  MakeCommand() {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'Create a feature',
      valueHelp: 'featureName',
    );
    argParser.addMultiOption(
      'lang',
      help: 'Add Languages For App',
    );
    argParser.addOption(
      'model',
      abbr: 'm',
      help: 'Create a Model Dart class',
      valueHelp: '''UserModel --json {"name": "ahmed", "age": 20}''',
    );
    argParser.addOption(
      'json',
      hide: true,
    );
    argParser.addOption(
      'path',
      hide: true,
    );
    argParser.addOption(
      'page',
      help: 'Create a Page in Feature',
      valueHelp: 'pageName',
    );
    argParser.addOption(
      'form',
      help: 'Create a Form in Feature',
      valueHelp: 'formName --feature featureName as home',
    );
    argParser.addMultiOption(
      'fields',
      hide: true,
      help: 'Add Languages For App',
    );
    argParser.addOption('method', hide: true);
    argParser.addOption('action-name', hide: true);
    argParser.addOption('api', hide: true);
    argParser.addOption('baseurl', hide: true);
  }

  @override
  String get description => 'Create Useful Files';

  @override
  String get name => 'make';

  @override
  void run() {
    if (argResults != null) {
      String? featureName = argResults!['feature'];
      List<String>? languages = argResults!['lang'];
      String? json = argResults!['json'];
      String? path = argResults!['path'];
      String? model = argResults!['model'];
      String? page = argResults!['page'];
      String? form = argResults!['form'];
      List<String>? fields = argResults!['fields'];
      if (page != null) {
        Creators.addPage(routeName: page, featureName: featureName);
      } else if (form != null) {
        Creators.addForm(
            featureName: featureName, formName: form, fields: fields);
      } else if (featureName != null) {
        Creators.createFeature(name: featureName);
      } else if (languages?.isNotEmpty == true) {
        print('lang: $languages');
        Creators.addLang(languages: languages);
      } else if (model != null && json != null) {
        generateModelClassFromJson(className: model, json: json, path: path);
      } else {
        print('Usage: flyer make [options]');
        print(argParser.usage);
      }
    }
  }
}
