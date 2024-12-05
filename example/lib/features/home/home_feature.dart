import 'pages/fff_page.dart';

import 'pages/ff_page.dart';

import 'pages/dd_page.dart';

import 'pages/dd_page.dart';

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
            builder: (_, state) => const AlsoPage()),
        GoRoute(
            path: '/dd', name: '/dd', builder: (_, state) => const DdPage()),
        GoRoute(
            path: '/dd', name: '/dd', builder: (_, state) => const DdPage()),
        GoRoute(
            path: '/ff', name: '/ff', builder: (_, state) => const FfPage()),
        GoRoute(
            path: '/fff', name: '/fff', builder: (_, state) => const FffPage())
      ];
}
