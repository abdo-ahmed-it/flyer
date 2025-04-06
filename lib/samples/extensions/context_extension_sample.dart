String contextExtensionSample() {
  return '''
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  AppLocalizations get loc => AppLocalizations.of(this)!;
}
  ''';
}