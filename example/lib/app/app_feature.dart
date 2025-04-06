import 'package:app_features/app_features.dart';
import '../config/app_config.dart';
import '../core/app_storage.dart';
import 'bloc/app_bloc.dart';

class AppFeature extends Feature {
  @override
  void get dependencies => {
        getIt.registerLazySingleton(() => AppBloc()),
        getIt.registerLazySingleton(() => AppStorage()),
      };

  @override
  String get name => '/app';

  @override
  List<GoRoute> get routes => [];
}
