import 'package:app_forms/app_forms.dart';

class LoginForm extends AppForm {

  final email = AppFormField(
    name: 'email',
  );final password = AppFormField(
    name: 'password',
  );

  LoginForm() {
    setFields([email, password]);
  }

  @override
  Future onSubmit(Map<String, dynamic>? values) async {}
}

  