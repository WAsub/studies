import 'package:flutter/material.dart';

class HusenColor {
  Color color;
  Color backSideColor;

  HusenColor({this.color, this.backSideColor,});

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'backSideColor': backSideColor,
    };
  }
  @override
  String toString() {
    return 'Thokin{color: $color, backSideColor: $backSideColor,}';
  }
}


class HusenContainer extends StatelessWidget {
  bool mekuriFlg;
  double height;
  double width;
  Widget child;
  Color color;
  Color backSideColor;
  HusenContainer({ 
    this.mekuriFlg,
    this.height,
    this.width,
    this.child,
    this.color,
    this.backSideColor,
  });
  @override
  Widget build(BuildContext context) {
    mekuriFlg = mekuriFlg == null ? true : mekuriFlg;
    if(height == null){ height = 300;}
    if(width == null){ width = 300;}
    if(color == null){ color = Colors.greenAccent;}
    if(backSideColor == null){ backSideColor = Colors.green;}

    return CustomPaint(
      child: this.child,
      size: Size(width, height),
      painter: HusenPainter(
        mekuriFlg: this.mekuriFlg,
        color: this.color,
        backSideColor: this.backSideColor,
      ),
    );
  }
}
class HusenPainter extends CustomPainter {
  bool mekuriFlg;
  Color color;
  Color backSideColor;
  HusenPainter({ 
    this.mekuriFlg,
    this.color,
    this.backSideColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    var path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 6 * 5);
    path.lineTo(size.width / 6 * 5, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);

    if(mekuriFlg){
      paint = new Paint();
      paint.color = backSideColor;
      path = new Path();

      path.moveTo(size.width / 6 * 5, size.height / 6 * 5);
      path.lineTo(size.width, size.height / 6 * 5);
      path.lineTo(size.width / 6 * 5, size.height);
      path.lineTo(size.width / 6 * 5, size.height / 6 * 5);
      canvas.drawPath(path, paint);
    }else{
      paint = new Paint();
      paint.color = color;
      path = new Path();

      path.moveTo(size.width, size.height);
      path.lineTo(size.width, size.height / 6 * 5);
      path.lineTo(size.width / 6 * 5, size.height);
      path.lineTo(size.width, size.height);
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
