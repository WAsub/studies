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
  static Future<MaterialColor> getBasicAndThemeColor() async {
    var key = await loadThemeType();
    MaterialColor themeColor = themeMap[key];
    MaterialColor colors =  MaterialColor(
      0xffffffff,
      <int, Color>{
        50 : Color(0xffffffff),
        100 : Color(0xff2b2b2b),
        200 : Color(0xffee836f),
        300 : Color(0xfffcd575),
        400 : Color(0xffbce2e8),
        500 : themeColor[300],
        600 : themeColor[400],
        700 : themeColor[500],
        800 : themeColor[600],
        900 : themeColor[800],
      },
    );
    return colors;
  }

  static Future<ThemeType> loadThemeType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (ThemeType.of(prefs.getString('theme_type')) ?? ThemeType.ROSE);
  }
}