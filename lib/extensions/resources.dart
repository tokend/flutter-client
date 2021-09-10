import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_template/resources/themes/Themes.dart';

extension GetAppLocalization on BuildContext {
  AppLocalizations get appLocalization => AppLocalizations.of(this)!;
}

extension GetColorTheme on BuildContext {
  BaseColorTheme get colorTheme => Theme.of(this).brightness == Brightness.light
      ? LightColorTheme()
      : DarkColorTheme();
}
