String mainSample({bool firebase = false}) {
  String firebaseImport = firebase
      ? "import 'package:firebase_core/firebase_core.dart';\nimport 'firebase_options.dart';\n"
      : '';
  String firebaseInit = firebase
      ? "\n  await Firebase.initializeApp(\n    options: DefaultFirebaseOptions.currentPlatform,\n  );"
      : '';
  return '''
import 'package:app_features/app_features.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'package:flutter/foundation.dart';
${firebaseImport}
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../config/app_config.dart';
import '../core/app_storage.dart';
import 'theme/app_theme.dart';
void main() async {
  await AppConfig.init();${firebaseInit}
  runApp(const RequestsInspector(
    enabled: kDebugMode,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ValueListenableBuilder(
          valueListenable: getIt.get<AppStorage>().appBoxListener(),
          builder: (context, box, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(
                builder: (_, c) => ResponsiveBreakpoints(
                  breakpoints: const [
                    Breakpoint(start: 0, end: 450, name: MOBILE),
                    Breakpoint(start: 451, end: 800, name: TABLET),
                    Breakpoint(start: 801, end: 1920, name: DESKTOP),
                    Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                  ],
                  child: c!,
                ),
              ),

              // themeMode: ThemeMode.light,
              themeMode: getIt.get<AppStorage>().getThemeMode(),
              routerConfig: AppFeatures.router,
              locale: Locale(getIt.get<AppStorage>().getLocale(), ''),
              supportedLocales: AppLocalizations.supportedLocales,

              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                // FormBuilderLocalizations.delegate,
              ],
              darkTheme: AppTheme.dark,
              theme: AppTheme.light,
            );
          }),
    );
  }
}
  ''';
}
