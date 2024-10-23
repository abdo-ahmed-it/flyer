import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  //This getter is instance of app localizations.
  //make as context.tr?.services
  AppLocalizations get loc => AppLocalizations.of(this)!;

  //this getter used of next step in TextFormField
  bool get next => FocusScope.of(this).nextFocus();

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension StringExtension on String? {
  bool get isEmptyOrNull => this == null || this!.isEmpty;
}

extension ListExtension on List? {
  bool get isEmptyOrNull => this == null || this!.isEmpty;
}
