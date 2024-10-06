String appStorageSample(){
  return '''
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app_storage.dart';

class AppStorage {
  static const _appBoxName = 'appBox';
  static const _themeMode = 'theme_mode';
  static const _locale = 'locale';
  static const _token = 'token';
  static const _defaultLocale = 'ar';
  static const _email = 'email';
  static const _password = 'password';
  static final Box _appBox = Hive.box(_appBoxName);

  static init() async {
    await Hive.initFlutter();
    await Hive.openBox(_appBoxName);
  }

  ValueListenable appBoxListener() {
    return _appBox.listenable(keys: [_themeMode, _locale, _token]);
  }

  ThemeMode getThemeMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    String mode =
        isDarkMode ? ThemeMode.dark.toString() : ThemeMode.light.toString();
    mode = _appBox.get(_themeMode, defaultValue: mode);

    return ThemeMode.values.firstWhere((element) => element.toString() == mode);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _appBox.put(_themeMode, themeMode.toString());
  }

  void setLocale(String locale) async {
    await _appBox.put(_locale, locale);
  }

  String getLocale() {
    return _appBox.get(_locale, defaultValue: _defaultLocale);
  }

  void setToken(String? token) async {
    await _appBox.put(_token, token);
  }

  String? getToken() {
    return _appBox.get(_token);
  }

  Future<void> setEmail(String? email) async {
    await _appBox.put(_email, email);
  }

  String? getEmail() {
    return _appBox.get(_email);
  }

  Future<void> setPassword(String? password) async {
    await _appBox.put(_password, password);
  }

  String? getPassword() {
    return _appBox.get(_password);
  }
}
  ''';
}