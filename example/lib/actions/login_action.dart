
import 'package:api_request/api_request.dart';

class LoginAction extends ApiRequestAction<LoginResponse> {
  @override
  bool get authRequired => false;

  @override
  RequestMethod get method => RequestMethod.POST;

  @override
  String get path => 'https://derman.code-link.com/api/auth/login';

  @override
  Map<String, dynamic> get toMap => null;

  @override
  ContentDataType? get contentDataType => null;

  @override
  ResponseBuilder<LoginResponse> get responseBuilder =>
      (json) => LoginResponse.fromJson(json);
}

  

class LoginResponse {
  String? phoneCode;
  String? phone;
  String? phoneText;
  String? message;

  LoginResponse({this.phoneCode, this.phone, this.phoneText, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phone_code'];
    phone = json['phone'];
    phoneText = json['phone_text'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_code'] = phoneCode;
    data['phone'] = phone;
    data['phone_text'] = phoneText;
    data['message'] = message;
    return data;
  }
}

