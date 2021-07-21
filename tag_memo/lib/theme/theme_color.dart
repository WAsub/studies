import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_type.dart';
import 'color.dart';

class ThemeColor {
  static Map<ThemeType, MaterialColor> themeMap = {
    ThemeType.ROSE: MyColor.rose,
    ThemeType.SKY: MyColor.sky,
  };

  static Future<MaterialColor> getThemeColor() async {
    var key = await loadThemeType();
    return themeMap[key];
  }

  static Future<ThemeType> loadThemeType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (ThemeType.of(prefs.getString('theme_type')) ?? ThemeType.ROSE);
  }
}