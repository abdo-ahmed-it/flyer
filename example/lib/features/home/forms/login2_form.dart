import 'package:app_forms/app_forms.dart';

class Login2Form extends AppForm {
  final name = AppFormField(
    name: 'name',
  );
  final password = AppFormField(
    name: 'password',
  );

  Login2Form() {
    setFields([name, password]);
  }

  @override
  Future onSubmit(Map<String, dynamic>? values) async {}
}
