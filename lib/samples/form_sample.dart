import 'package:flyer/core/app_helper.dart';

String formSample(String name, List<String> fields) {
  String a = '';
  for (var field in fields) {
    a += '''final $field = AppFormField(
    name: '$field',
  );''';
  }
  return '''
import 'package:app_forms/app_forms.dart';

class ${AppHelper.toClassName(name)}Form extends AppForm {

  $a

  ${AppHelper.toClassName(name)}Form() {
    setFields($fields);
  }

  @override
  Future onSubmit(Map<String, dynamic>? values) async {}
}

  ''';
}
