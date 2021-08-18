import 'package:flutter/material.dart';


class CustomTile extends StatelessWidget {
  Widget title;
  Widget trailing;
  final double height;
  final Color tileColor;
  Function() onTap;
  Function() onLongPress;
  
  CustomTile({
    this.title,
    this.trailing,
    this.height = 56.0,
    this.tileColor = Colors.white,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    this.title = this.title == null ? Container() : this.title;
    this.trailing = this.trailing == null ? Container() : this.trailing;
    this.onTap = this.onTap == null ? (){} : this.onTap;
    this.onLongPress = this.onLongPress == null ? (){} : this.onLongPress;

      return LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(left: 15,right: 15,),
            height: this.height,
            color: this.tileColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                this.title,
                this.trailing
              ],
            ),
          ),
          onTap: (){
            this.onTap();
          },
          onLongPress: (){
            this.onLongPress();
          },
        );
      });
  }
}
