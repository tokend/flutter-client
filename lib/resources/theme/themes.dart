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
  final Color suffixIcons = Color(0xFFFFFFFF);
  final Color hint = Color(0xFFFFFFFF);
  final Color buttonDisabled = Color(0xFFFFFFFF);
  final Color negative = Color(0xFFFFFFFF);
  final Color positive = Color(0xFFFFFFFF);
  final Color basic = Color(0xFFFFFFFF);
  final Color loading = Color(0xFFFFFFFF);
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
  final Color suffixIcons = Color(0xFF9695A8);

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
}
