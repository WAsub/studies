import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'theme_type.dart';
import 'color.dart';

typedef Widget ThemedWidgetBuilder(BuildContext context, ThemeData data);

typedef ThemeData ThemeDataWithBrightnessBuilder(Brightness brightness);

class DynamicTheme extends StatefulWidget {
  final ThemedWidgetBuilder themedWidgetBuilder;
  final ThemeType defaultThemeTypes; // 初期値
  final bool loadThemeTypesOnStart;

  const DynamicTheme({
    Key key,
    this.themedWidgetBuilder,
    this.defaultThemeTypes = ThemeType.ROSE,
    this.loadThemeTypesOnStart = true,
  }) : super(key: key);

  @override
  DynamicThemeState createState() => new DynamicThemeState();

  static DynamicThemeState of(BuildContext context) {
    // return context.ancestorStateOfType(const TypeMatcher<DynamicThemeState>());
    return context.findAncestorStateOfType<DynamicThemeState>();
  }
}

class DynamicThemeState extends State<DynamicTheme> {
  ThemeData _data;

  ThemeType _themeType;

  bool _shouldLoadThemeTypes;

  static const String _themeTypeKey = 'theme_type';

  get data => _data;

  static Map<ThemeType, ThemeData> themeMap = {
    ThemeType.ROSE: AppTheme.theme_rose(),
    ThemeType.SKY: AppTheme.theme_sky(),
  };

  void _initVariables() {
    _themeType = widget.defaultThemeTypes;
    _shouldLoadThemeTypes = widget.loadThemeTypesOnStart;
  }
  @override
  void initState() {
    super.initState();
    _initVariables();
    _data = new ThemeData(
      primaryColor: MyColor.rose[2],
      accentColor: MyColor.rose[1],
      selectedRowColor: MyColor.rose[4],
      brightness: Brightness.light,
    );

    loadThemeType().then((ThemeType themeType) {
      setState(() {
        _data = themeMap[themeType];
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _data = themeMap[_themeType];
  }

  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = themeMap[_themeType];
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _data);
  }

  void setTheme(ThemeType theme) async {
    setState(() {
      this._data = themeMap[theme];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeTypeKey, theme.toString());
  }

  Future<ThemeType> loadThemeType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (ThemeType.of(prefs.getString(_themeTypeKey)) ?? ThemeType.ROSE);
  }
}