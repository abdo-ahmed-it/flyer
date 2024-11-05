import 'package:app_features/app_features.dart';

import '../../config/app_config.dart';
import 'bloc/home_bloc.dart';
import 'home_page.dart';
import 'pages/also_page.dart';
import 'pages/details_page.dart';

class HomeFeature extends Feature {
  @override
  void get dependencies => {
        getIt.registerLazySingleton(() => HomeBloc()),
      };

  @override
  String get name => '/home';

  @override
  List<GoRoute> get routes => [
        GoRoute(
            path: name, name: name, builder: (_, state) => const HomePage()),
        GoRoute(
            path: '/details',
            name: '/details',
            builder: (_, state) => const DetailsPage()),
        GoRoute(
            path: '/also',
            name: '/also',
            builder: (_, state) => const AlsoPage())
      ];
}
