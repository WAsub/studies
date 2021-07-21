import 'package:flutter/material.dart';


class CustomText extends StatelessWidget {
  String data;
  TextStyle style;
  TextAlign textAlign;
  TextDirection textDirection;
  TextOverflow overflow;
  int maxLines;
  
  CustomText(
    this.data,{
    this.style,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    double widgetHeight;
    double widgetWidth;
    List<String> datas = this.data.split('\n');

    return LayoutBuilder(builder: (context, constraints) {
        widgetHeight = constraints.maxHeight;
        widgetWidth = constraints.maxWidth;

        return Container(
          height: widgetHeight, width: widgetWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: datas.length <= this.maxLines ?
            List.generate(datas.length, (index) {
              return Text(datas[index], overflow: this.overflow,);
            }) : 
            List.generate(this.maxLines+1, (index) {
              if(index == this.maxLines){
                return Text("...");
              }
              return Text(datas[index], overflow: this.overflow,);
            }),
          ),
        );
    });
  }
}
