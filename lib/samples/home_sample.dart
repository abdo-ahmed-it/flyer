import 'package:flyer/functions/get_app_name.dart';

Future<String> homeSample()async{
  String appName =await getAppName();
  return '''
import 'package:flutter/material.dart';
import 'package:$appName/core/extensions/context_extension.dart';

import '../../config/app_config.dart';
import '../../core/app_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              if (getIt.get<AppStorage>().getLocale() == 'ar') {
                getIt.get<AppStorage>().setLocale('en');
              } else {
                getIt.get<AppStorage>().setLocale('ar');
              }
            },
          ),
          IconButton(
            icon: Icon(getIt.get<AppStorage>().getThemeMode() == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              if (getIt.get<AppStorage>().getThemeMode() == ThemeMode.light) {
                getIt.get<AppStorage>().setThemeMode(ThemeMode.dark);
              } else {
                getIt.get<AppStorage>().setThemeMode(ThemeMode.light);
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: Center(
        child: Text(context.loc.home),
      ),
    );
  }
}

  ''';
}