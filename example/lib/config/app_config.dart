import 'package:api_request/api_request.dart';
import 'package:app_features/app_features.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../app/app_feature.dart';
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
      AppFeature(),
      SplashFeature(),
      HomeFeature(),
    ]);
  }
}
