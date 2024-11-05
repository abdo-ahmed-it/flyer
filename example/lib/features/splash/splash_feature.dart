import 'pages/home_page.dart';

import 'pages/details_page.dart';

import 'package:app_features/app_features.dart';
import 'bloc/splash_bloc.dart';
import '../../config/app_config.dart';
import 'splash_page.dart';

class SplashFeature extends Feature {
  @override
  void get dependencies => {
        getIt.registerLazySingleton(() => SplashBloc()),
      };

  @override
  String get name => '/';

  @override
  List<GoRoute> get routes => [
        GoRoute(
            path: name, name: name, builder: (_, state) => const SplashPage()),
        GoRoute(
            path: '/details',
            name: '/details',
            builder: (_, state) => const DetailsPage()),
        GoRoute(
            path: '/home',
            name: '/home',
            builder: (_, state) => const HomePage())
      ];
}
