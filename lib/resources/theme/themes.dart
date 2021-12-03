import 'package:flutter/material.dart';

abstract class BaseColorTheme {
  final Color background = Color(0xFFFFFFFF);
  final Color darkBackground = Color(0xFFF5F5F9);
  final Color drawerBackground = Color(0xFFF5F5F9);
  final Color accent = Color(0xFFFFFFFF);
  final Color primary = Color(0xFFFFFFFF);
  final Color middlePrimary = Color(0xFFFFFFFF);
  final Color borderUnfocused = Color(0xFFFFFFFF);
  final Color primaryText = Color(0xFFFFFFFF);
  final Color secondaryText = Color(0xFFFFFFFF);
  final Color headerText = Color(0xFFFFFFFF);
  final Color grayText = Color(0xFFFFFFFF);
  final Color suffixIcons = Color(0xFFFFFFFF);
  final Color hint = Color(0xFFFFFFFF);
  final Color buttonDisabled = Color(0xFFFFFFFF);
  final Color negative = Color(0xFFFFFFFF);
  final Color positive = Color(0xFFFFFFFF);
  final Color basic = Color(0xFFFFFFFF);
  final Color loading = Color(0xFFFFFFFF);
  final Color primaryLight = Color(0xFFFFFFFF);
  final Color errorRejectAlert = Color(0xFFFFFFFF);
  final Color errorRejectAlertLight = Color(0xFFFFFFFF);
  final Color yellow = Color(0xFFFFFFFF);
  final Color yellowLight = Color(0xFFFFFFFF);
  final Color approved = Color(0xFFFFFFFF);
  final Color approvedLight = Color(0xFFFFFFFF);
}

class LightColorTheme implements BaseColorTheme {
  static final _instance = LightColorTheme._internal();

  factory LightColorTheme() {
    return _instance;
  }

  LightColorTheme._internal();

  @override
  final Color accent = Color(0xff0b2962);

  @override
  final Color primary = Color(0xff7b6eff);

  @override
  final Color middlePrimary = Color(0xFF5B5B7E);

  @override
  final Color background = Color(0xFFF5F8FB);

  @override
  final Color darkBackground = Color(0xFFF5F5F9);

  @override
  final Color borderUnfocused = Color(0xFFE0E0E0);

  @override
  final Color primaryText = Color(0xFF010000);

  @override
  final Color suffixIcons = Color(0x1A7B6EFF);

  @override
  final Color hint = Color(0xFF9695A8);

  @override
  final Color buttonDisabled = Color(0xFFE0E0E0);

  @override
  final Color negative = Color(0xFFF86E6E);

  @override
  final Color positive = Color(0xFF47B977);

  @override
  final Color secondaryText = Color(0xFFFFFFFF);

  @override
  final Color basic = Color(0xFF656CEE);

  @override
  Color get loading => Color(0x80656CEE);

  @override
  Color get drawerBackground => Color(0xFF0B2962);

  @override
  Color get headerText => Color(0xFF200E32);

  @override
  Color get grayText => Color(0xFF7D8592);

  @override
  Color get primaryLight => Color(0x1a7b6eff);

  @override
  Color get errorRejectAlert => Color(0xFFFF4646);

  @override
  Color get errorRejectAlertLight => Color(0x1AFF4646);

  @override
  Color get yellow => Color(0xFFF58500);

  @override
  Color get yellowLight => Color(0x1AF58500);

  @override
  Color get approved => Color(0xFF329D3D);

  @override
  Color get approvedLight => Color(0x1A329D3D);
}

class DarkColorTheme implements BaseColorTheme {
  static final _instance = DarkColorTheme._internal();

  factory DarkColorTheme() {
    return _instance;
  }

  DarkColorTheme._internal();

  //todo init your colors for dark theme
  @override
  final Color accent = Color(0xFFFFFFFF);

  @override
  final Color primary = Color(0xFF6454ee);

  @override
  final Color middlePrimary = Color(0xFFFFFFFF);

  @override
  final Color background = Color(0xFFFFFFFF);

  @override
  final Color darkBackground = Color(0xFFFFFFFF);

  @override
  final Color borderUnfocused = Color(0xFFFFFFFF);

  @override
  final Color primaryText = Color(0xFFFFFFFF);

  @override
  final Color suffixIcons = Color(0xFFFFFFFF);

  @override
  final Color hint = Color(0xFFFFFFFF);

  @override
  final Color buttonDisabled = Color(0xFFFFFFFF);

  @override
  final Color negative = Color(0xFFFFFFFF);

  @override
  final Color positive = Color(0xFFFFFFFF);

  @override
  final Color secondaryText = Color(0xFFFFFFFF);

  @override
  final Color basic = Color(0xFFFFFFFF);

  @override
  Color get loading => Color(0x77656CEE);

  @override
  Color get drawerBackground => Color(0xFF0B2962);

  @override
  Color get headerText => Color(0xFF200E32);

  Color get grayText => Color(0xFF7D8592);

  @override
  Color get primaryLight => Color(0xff7b6eff);

  @override
  Color get errorRejectAlert => Color(0xFFFF4646);

  @override
  Color get errorRejectAlertLight => Color(0x1AFF4646);

  @override
  Color get yellow => Color(0xFFF58500);

  @override
  Color get yellowLight => Color(0x1AF58500);

  @override
  Color get approved => Color(0xFF329D3D);

  @override
  Color get approvedLight => Color(0x1A329D3D);
}
