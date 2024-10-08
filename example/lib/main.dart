import 'package:app_features/app_features.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../config/app_config.dart';
import '../core/app_storage.dart';
import 'theme/app_theme.dart';
void main() async {
  await AppConfig.init();
  runApp(const MyApp());
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
                builder: (_, c) => ResponsiveWrapper.builder(
                  ClampingScrollWrapper.builder(context, c!),
                  breakpoints: const [
                    ResponsiveBreakpoint.resize(200,
                        name: PHONE, scaleFactor: 0.8),
                    ResponsiveBreakpoint.resize(350,
                        name: MOBILE, scaleFactor: 1),
                    ResponsiveBreakpoint.autoScale(600,
                        name: TABLET, scaleFactor: 1.2),
                    ResponsiveBreakpoint.resize(800,
                        name: DESKTOP, scaleFactor: 1.4),
                    ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
                  ],
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
  