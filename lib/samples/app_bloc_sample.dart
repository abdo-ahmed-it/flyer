String appBlocSample({bool firebase = false}) {
  String firebaseImports = firebase
      ? "import '../../core/app_notifications.dart';\nimport '../utils/notification_util.dart';\nimport '../../core/app_storage.dart';\nimport 'package:api_request/api_request.dart';\n"
      : '';
  String firebaseInit = firebase
      ? '''

  Future<void> initNotification() async {
    await AppNotifications.instance().sendRequest();
    await AppNotifications.instance().init(
      onOpenedApp: (message) {
        // Handle notification tap
      },
      onReceived: (message) {
        final body = message.notification?.body;
        if (body != null) {
          NotificationUtil.showSuccess(body);
        }
      },
      onBackgroundMessage: (message) {},
    );
  }

  Future<void> setFcmToken() async {
    await AppNotifications.instance().getToken((token) {
      if (getIt.get<AppStorage>().getToken() != null) {
        SimpleApiRequest.withAuth().post(
          '/update-fcm-token',
          data: {'fcm_token': token},
        );
      }
    });
  }'''
      : '';

  String initBody = firebase
      ? '''
    await initNotification();
    await setFcmToken();'''
      : '    // Initialize app-level logic here';

  return '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_config.dart';
$firebaseImports
import 'app_state.dart';

class AppBloc extends Cubit<AppState> {

  static AppBloc get to => getIt.get();

  AppBloc() : super(const AppState());

  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> init() async {
$initBody
  }$firebaseInit
}
''';
}

String appStateSample() {
  return '''
import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final int currentIndex;

  const AppState({
    this.currentIndex = 0,
  });

  AppState copyWith({
    int? currentIndex,
  }) => AppState(
    currentIndex: currentIndex ?? this.currentIndex,
  );

  @override
  List<Object?> get props => [currentIndex];
}
''';
}
