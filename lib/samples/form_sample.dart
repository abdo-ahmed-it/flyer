
import 'package:app_creator/core/extensions.dart';

String formSample(String name,List<String>fields){
  String a='';
  for(var field in fields){
    a+='''final $field = AppFormField(
    name: '$field',
  );''';
  }
  return '''
import 'package:app_forms/app_forms.dart';

class ${name.toCapitalized}Form extends AppForm {

  $a

  ${name.toCapitalized}Form() {
    setFields($fields);
  }

  @override
  Future onSubmit(Map<String, dynamic>? values) async {}
}

  ''';
}