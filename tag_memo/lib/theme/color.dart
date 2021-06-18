import 'package:flutter/material.dart';

class MyColor{
  static List<String> themeName = ["ローズ", "スカイ"];
  static Map<int,MaterialColor> themeColor = {0: rose, 1: sky};

  static const int _rosePrimaryValue = 0xffe95464;
  static const MaterialColor rose = MaterialColor(
    _rosePrimaryValue,
    <int, Color>{
      0 : Color(0xffffffff),
      1 : Color(0xff9d8e87),//ローズグレイ
      2 : Color(0xffe95464),//ローズ
      3 : Color(0xfff19ca7),//ローズピンク
      4 : Color(0xffffffff),
      5 : Color(0xffffffff),
      6 : Color(0xffffffff),
      7 : Color(0xffffffff),
      8 : Color(0xffffffff),
      9 : Color(0xffffffff),
    },
  );
  static const int _skyPrimaryValue = 0xff6c9bd2;
  static const MaterialColor sky = MaterialColor(
    _skyPrimaryValue,
    <int, Color>{
      0 : Color(0xffffffff),
      1 : Color(0xff719bad),//シャドウブルー
      2 : Color(0xff6c9bd2),//ヒヤシンス
      3 : Color(0xffa0d8ef),//スカイブルー
      4 : Color(0xffffffff),
      5 : Color(0xffffffff),
      6 : Color(0xffffffff),
      7 : Color(0xffffffff),
      8 : Color(0xffffffff),
      9 : Color(0xffffffff),
    },
  );
}