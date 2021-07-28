import 'package:flutter/material.dart';
import 'theme/color.dart';
import 'theme/dynamic_theme.dart';
import 'theme/theme_type.dart';

class SetTheme extends StatefulWidget {
  @override
  _SetThemeState createState() => _SetThemeState();
}

class _SetThemeState extends State<SetTheme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('テーマカラー設定'),),
      /******************************************************* AppBar*/
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.separated(
            itemCount: MyColor.themeName.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async{
                  ThemeType themeType = ThemeType.values()[index];
                  String value = themeType.toString();
                  DynamicTheme.of(context).setTheme(ThemeType.of(value));
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15,right: 15,),
                  height: 56.0,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        MyColor.themeName[index],
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16,),
                      ),
                      Row(children: <Widget>[
                        Icon(Icons.stop_circle,color: MyColor.themeColor[index][100],),
                        Icon(Icons.stop_circle,color: MyColor.themeColor[index][200],),
                        Icon(Icons.stop_circle,color: MyColor.themeColor[index][300],),
                      ]),
                    ],
                  ),
                ),
                
              );
            },
            separatorBuilder: (context, index){
              return Divider(height:3,);
            },
          );
        }
      ),
    );
  }
}