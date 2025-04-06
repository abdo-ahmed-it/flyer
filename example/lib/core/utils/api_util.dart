import 'package:api_request/api_request.dart';
import 'package:example/app/utils/notification_util.dart';
import 'package:example/config/app_config.dart';
import 'package:example/core/app_storage.dart';
import 'package:example/core/extensions/context_extension.dart';
import 'package:flutter/widgets.dart';

class ApiUtils {
  ApiUtils.init(BuildContext context) {
    ApiRequestOptions.instance?.config(
      baseUrl: 'https://derman.code-link.com/api/',
      getToken: () => getIt.get<AppStorage>().getToken(),
      tokenType: ApiRequestOptions.bearer,
      enableLog: true,
      onError: (error) {
        NotificationUtil.showError(error.message);
      },
      unauthenticated: () {
        //Force logout user form app
        getIt.get<AppStorage>().setToken(null);
      },
      defaultHeaders: {'Content-Language': context.locale.languageCode},
    );
  }

  static void setLanguage(String languageCode) {
    ApiRequestOptions.instance
        ?.config(defaultHeaders: {'Content-Language': languageCode});
    ApiRequestOptions.refreshConfig();
    getIt.get<AppStorage>().setLocale(languageCode);
  }
}
