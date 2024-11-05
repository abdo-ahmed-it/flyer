import '../features/orders2/orders2_feature.dart';
import '../features/orders/orders_feature.dart';
import 'package:api_request/api_request.dart';
import 'package:app_features/app_features.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../app/utils/notification_util.dart';
import '../core/app_storage.dart';
import '../features/home/home_feature.dart';
import '../features/splash/splash_feature.dart';

final getIt = GetIt.instance;

class AppConfig {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppStorage.init();

    AppFeatures.config(features: [
      SplashFeature(),
      HomeFeature(),
      OrdersFeature(),
      Orders2Feature()
    ]);
    initApiActions();
  }

  static void initApiActions() {
    ApiRequestOptions.instance?.config(
      baseUrl: '',
      getToken: () => getIt.get<AppStorage>().getToken(),
      tokenType: ApiRequestOptions.bearer,
      enableLog: true,
      unauthenticated: () {
        //Force logout user form app
        getIt.get<AppStorage>().setToken(null);
      },
      defaultHeaders: {"Content-Language": getIt.get<AppStorage>().getLocale()},
      onError: (e) {
        if (e.statusCode == 408) {
          NotificationUtil.showError('برجاء التحقق من اتصال جهازك بالانترنت');
        } else {
          NotificationUtil.showError(e.message);
        }
      },
    );
  }
}
