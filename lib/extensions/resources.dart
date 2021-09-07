import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/resources/theme/themes.dart';

extension GetColorTheme on BuildContext {
  BaseColorTheme get colorTheme =>
      Theme
          .of(this)
          .brightness == Brightness.light
          ? LightColorTheme()
          : DarkColorTheme();
}
