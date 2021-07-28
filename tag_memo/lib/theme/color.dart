import 'package:flutter/material.dart';

class MyColor{
  static List<String> themeName = ["ローズ", "スカイ"];
  static Map<int,MaterialColor> themeColor = {0: rose, 1: sky};

  static const int _rosePrimaryValue = 0xffe95464;
  static const MaterialColor rose = MaterialColor(
    _rosePrimaryValue,
    <int, Color>{
      50 : Color(0xffffffff),
      100 : Color(0xff9d8e87),//ローズグレイ
      200 : Color(0xffe95464),//ローズ
      300 : Color(0xfff19ca7),//ローズピンク
      400 : Color(0xffea553a),
      500 : Color(0xfffdd35c),
      600 : Color(0xffd9e367),
      700 : Color(0xff003f8e),
      800 : Color(0xffb79fcb),
      900 : Color(0xffe29399),
    },
  );
  static const int _skyPrimaryValue = 0xff6c9bd2;
  static const MaterialColor sky = MaterialColor(
    _skyPrimaryValue,
    <int, Color>{
      50 : Color(0xffffffff),
      100 : Color(0xff719bad),//シャドウブルー
      200 : Color(0xff6c9bd2),//ヒヤシンス
      300 : Color(0xffa0d8ef),//スカイブルー
      400 : Color(0xffea553a),
      500 : Color(0xfff19072),
      600 : Color(0xff001e43),
      700 : Color(0xffd3cfd9),
      800 : Color(0xff895b8a),
      900 : Color(0xfff6bfbc),
    },
  );
}