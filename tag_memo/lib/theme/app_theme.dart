import 'package:flutter/material.dart';
import 'color.dart';

class AppTheme {
  static ThemeData theme_rose() {
    return ThemeData(
      primaryColor: MyColor.rose[100],
      accentColor: MyColor.rose[200],
      selectedRowColor: MyColor.rose[300],
      primarySwatch: MyColor.rose,
      brightness: Brightness.light,
    );
  }
  static ThemeData theme_sky() {
    return ThemeData(
      primaryColor: MyColor.sky[100],
      accentColor: MyColor.sky[200],
      selectedRowColor: MyColor.sky[300],
      primarySwatch: MyColor.sky,
      brightness: Brightness.light,
    );
  }
  static ThemeData theme_pastel() {
    return ThemeData(
      primaryColor: MyColor.pastel[100],
      accentColor: MyColor.pastel[200],
      selectedRowColor: MyColor.pastel[300],
      primarySwatch: MyColor.pastel,
      brightness: Brightness.light,
    );
  }
}