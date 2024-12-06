import 'package:app_features/app_features.dart';
import 'bloc/home_bloc.dart';
import '../../config/app_config.dart';
import 'home_page.dart';

class HomeFeature extends Feature {
  @override
  void get dependencies => {
        getIt.registerLazySingleton(() => HomeBloc()),
      };
  @override
  String get name => '/home';

  @override
  List<GoRoute> get routes => [
        GoRoute(path: name, name: name, builder: (_, state) => const HomePage())
      ];
}
