import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension GetAppLocalization on BuildContext {
  AppLocalizations get appLocalization => AppLocalizations.of(this)!;
}
