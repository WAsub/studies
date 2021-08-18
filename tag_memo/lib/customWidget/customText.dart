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
    return LayoutBuilder(builder: (context, constraints) {
      double widgetHeight = constraints.maxHeight;
      double widgetWidth = constraints.maxWidth;
      List<String> datas = this.data.split('\n');
      this.maxLines = this.maxLines == null ? datas.length : this.maxLines;

        return Container(
          height: widgetHeight, width: widgetWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: datas.length <= this.maxLines ?
            List.generate(datas.length, (index) {
              return Text(datas[index], overflow: this.overflow, style: this.style, textAlign: this.textAlign, textDirection: this.textDirection);
            }) : 
            List.generate(this.maxLines+1, (index) {
              if(index == this.maxLines){
                return Text("...", style: this.style, textAlign: this.textAlign, textDirection: this.textDirection);
              }
              return Text(datas[index], overflow: this.overflow, style: this.style, textAlign: this.textAlign, textDirection: this.textDirection);
            }),
          ),
        );
    });
  }
}
