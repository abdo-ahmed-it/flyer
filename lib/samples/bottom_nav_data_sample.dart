import 'package:flyer/functions/get_app_name.dart';

Future<String> bottomNavDataSample() async {
  String appName = await getAppName();
  return '''
import 'package:flutter/material.dart';
import 'package:$appName/app/models/bottom_nav_item_model.dart';
import 'package:$appName/features/home/home_page.dart';
import 'package:$appName/features/account/account_page.dart';

class BottomNavData {
  List<BottomNavItemModel> data = [
    BottomNavItemModel(
      page: const HomePage(),
      icon: Icons.home,
      label: 'Home',
      index: 0,
    ),
    BottomNavItemModel(
      page: const AccountPage(),
      icon: Icons.person,
      label: 'Account',
      index: 1,
    ),
  ];
}
''';
}
