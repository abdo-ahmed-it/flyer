import 'package:args/command_runner.dart';
import 'package:flyer/core/colors_text.dart';
import 'package:flyer/creatores.dart';

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
      String? page = argResults!['page'];
      String? form = argResults!['form'];
      List<String>? fields = argResults!['fields'];

      if (page != null) {
        print(
            '${ColorsText.blue}📄 Creating page: ${ColorsText.cyan}$page${ColorsText.reset}');
        if (featureName != null) {
          print(
              '${ColorsText.gray}   Feature: $featureName${ColorsText.reset}\n');
        }
        Creators.addPage(routeName: page, featureName: featureName);
        print(
            '${ColorsText.green}✓ Page created successfully${ColorsText.reset}');
      } else if (form != null) {
        print(
            '${ColorsText.blue}📝 Creating form: ${ColorsText.cyan}$form${ColorsText.reset}');
        if (featureName != null) {
          print(
              '${ColorsText.gray}   Feature: $featureName${ColorsText.reset}');
        }
        if (fields != null && fields.isNotEmpty) {
          print(
              '${ColorsText.gray}   Fields: ${fields.join(', ')}${ColorsText.reset}\n');
        }
        Creators.addForm(
            featureName: featureName, formName: form, fields: fields);
        print(
            '${ColorsText.green}✓ Form created successfully${ColorsText.reset}');
      } else if (featureName != null) {
        print(
            '${ColorsText.blue}🎯 Creating feature: ${ColorsText.cyan}$featureName${ColorsText.reset}\n');
        Creators.createFeature(name: featureName);
        print(
            '${ColorsText.green}✓ Feature created successfully${ColorsText.reset}');
      } else if (languages?.isNotEmpty == true) {
        print(
            '${ColorsText.blue}🌍 Adding languages: ${ColorsText.cyan}${languages?.join(', ')}${ColorsText.reset}\n');
        Creators.addLang(languages: languages);
        print(
            '${ColorsText.green}✓ Languages added successfully${ColorsText.reset}');
      } else {
        print(
            '${ColorsText.yellow}Usage: flyer make [options]${ColorsText.reset}');
        print(argParser.usage);
      }
    }
  }
}
