import 'package:app_features/app_features.dart';
import 'bloc/app_bloc.dart';
import '../../config/app_config.dart';

class AppFeature extends Feature {
  @override
  void get dependencies => {
        getIt.registerLazySingleton(() => AppBloc()),
      };
  @override
  String get name => '/app';

  @override
  List<GoRoute> get routes => [];
}
