import 'package:flutter/material.dart';

import 'dart:math' as math;

class HusenContainer extends StatefulWidget {
  int crossAxisCount = 3;
  double crossAxisSpacing = 4.0;
  double mainAxisSpacing = 4.0;
  List<Widget> children = [];

  HusenContainer({
    Key key,
    this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.children,
  }) : super(key: key);

  @override
  HusenContainerState createState() => HusenContainerState();
}

class HusenContainerState extends State<HusenContainer> {
  double wigetWidth;
  double gredSize;
  List<Widget> item;
  bool flg = true;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300),
      painter: HusenPainter(),
    );
  }
}

class HusenPainter extends CustomPainter {
  // // final double par;
  // HusenPainter({
  //   // this.par,
  // });
  @override
  void paint(Canvas canvas, Size size) {
    // final rect = Rect.fromLTRB(20, 20, 280, 280);
    // final startAngle = -60 * math.pi / 180;
    // final sweepAngle = 300 * math.pi / 180;
    // final useCenter = false;
    // final paint = Paint()
    //   ..color = Colors.pinkAccent
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 28
    //   ..strokeCap = StrokeCap.round;
    // canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

    // final paint2 = Paint()
    //   ..color = Colors.purpleAccent
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 28
    //   ..strokeCap = StrokeCap.round;
    // final sweepAngle2 = 300 * math.pi / 180 * par;
    // canvas.drawArc(rect, startAngle, sweepAngle2, useCenter, paint2);

    var paint = Paint();
    var path = Path();
    paint.color = Colors.greenAccent;
    // var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // canvas.drawRect(rect, paint);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 6 * 5);
    // path.lineTo(size.width / 6 * 5, size.height / 6 * 5);
    path.lineTo(size.width / 6 * 5, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);

    var paint5 = new Paint();
    var path5 = new Path();
    paint5.color = Colors.green;
    path5.moveTo(size.width / 6 * 5, size.height / 6 * 5);
    path5.lineTo(size.width, size.height / 6 * 5);
    path5.lineTo(size.width / 6 * 5, size.height);
    path5.lineTo(size.width / 6 * 5, size.height / 6 * 5);
    canvas.drawPath(path5, paint5);

    // 四角（外線）
    var paint2 = new Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // path.quadraticBezierTo();
    // path.moveTo(size.width / 3, size.height / 3);
    // path.lineTo(size.width / 3 * 2, size.height / 3);
    // path.lineTo(size.width / 3 * 2, size.height / 3 * 2);
    // path.lineTo(size.width / 3, size.height / 3 * 2);
    // path.close();
    // canvas.drawPath(path, paint);

    // var rect2 = Rect.fromLTWH(size.width / 3 * 1, size.height / 3 * 1, size.width / 3 * 2, size.height / 3 * 2);
    // final startAngle = -1 * math.pi / 180;
    // final sweepAngle = math.pi / 180 * 91;
    // canvas.drawArc(rect2, startAngle, sweepAngle, true, paint);

    // var rect3 = Rect.fromLTWH(size.width / 3 * 1.5, size.height / 3 * 2, size.width / 3, size.height / 3);
    // final startAngle3 = math.pi / 180;
    // final sweepAngle3 = math.pi / 180 * 90;
    // canvas.drawArc(rect3, startAngle3, sweepAngle3, false, paint2);
    // var rect4 = Rect.fromLTWH(size.width / 3 * 2, size.height / 3 * 1.5, size.width / 3, size.height / 3);
    // final startAngle4 = math.pi / 180;
    // final sweepAngle4 = math.pi / 180 * 90;
    // canvas.drawArc(rect4, startAngle4, sweepAngle4, false, paint2);

    // var paint3 = new Paint()
    //   ..color = Colors.orange
    //   ..strokeCap = StrokeCap.round
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2;
    // paint3 = new Paint()..color = Colors.deepPurpleAccent;
    // var path3 = Path();
    // path3.moveTo(0, 0);
    // path3.lineTo(0, size.height);
    // path3.lineTo(size.width / 3, size.height);
    // path3.quadraticBezierTo(size.width / 10 * 6, size.height / 10 * 10, size.width / 10 * 9.75, size.height / 10 * 9.25);
    // path3.quadraticBezierTo(size.width / 10 * 10, size.height / 10 * 6.5, size.width, size.height / 2);
    // path3.lineTo(size.width, 0);
    // path3.lineTo(0, 0);
    // canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
