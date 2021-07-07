import 'package:flutter/material.dart';
import 'package:tag_memo/customWidget/husenContainer.dart';
import "dart:async";


class ReorderableGridView2 extends StatefulWidget {
  int crossAxisCount = 3;
  double AxisSpacing = 4.0;
  List<Widget> children = [];
  List<HusenColor> childrenColor = [];

  ReorderableGridView2({
    Key key,
    this.crossAxisCount,
    this.AxisSpacing,
    this.children,
  }) : super(key: key);

  @override
  ReorderableGridView2State createState() => ReorderableGridView2State();
}
class ReorderableGridView2State extends State<ReorderableGridView2> {
  double wigetWidth;
  double gredSize;
  List<Widget> item;
  bool flg = true;
  List<bool> mekuriflgs = [];
  List<bool> nonflgs = [];
  List<double> tops = [];
  List<double> lefts = [];
  final _streamController = StreamController();
  // double btm = 0;

  @override
  Widget build(BuildContext context) {
    item = widget.children;
    if(widget.childrenColor == null){
      widget.childrenColor = List.generate(item.length, (index) {
        return HusenColor(color: Colors.blueAccent[100], backSideColor: Colors.blue);
      });
    }
    
    return LayoutBuilder(builder: (context, constraints) {
      wigetWidth = constraints.maxWidth;
      gredSize = (wigetWidth - widget.AxisSpacing * (widget.crossAxisCount - 1)) / 3;
    for(int index = 0; index < widget.children.length; index++){
      // var a = (index ~/ widget.crossAxisCount) * gredSize;
      tops.add((index ~/ widget.crossAxisCount * gredSize) + index ~/ widget.crossAxisCount * widget.AxisSpacing);
      lefts.add((index % widget.crossAxisCount * gredSize) + index % widget.crossAxisCount * widget.AxisSpacing);
      // tops[index] = (index ~/ widget.crossAxisCount * gredSize) + index ~/ widget.crossAxisCount * widget.AxisSpacing;
      // lefts[index] = (index % widget.crossAxisCount * gredSize) + index % widget.crossAxisCount * widget.AxisSpacing;
    }
    _streamController.sink.add([widget.children, tops, lefts]);


      return StreamBuilder(
          // 指定したstreamにデータが流れてくると再描画される
          stream: _streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            if(snapShot.hasData){
              return Stack(
                  children: List.generate(snapShot.data[0].length, (index) {
                    
                    return Positioned(
                        top: snapShot.data[1][index],
                        left: snapShot.data[2][index],
                        child:GestureDetector(
                          // 長押しした時の処理
                          onLongPress: () {
                            print("Long");
                          },
                          onLongPressMoveUpdate: (LongPressMoveUpdateDetails details){
                            print(details.globalPosition.dy);
                            tops[index] = details.globalPosition.dy;
                            _streamController.sink.add([widget.children, tops, lefts]);
                          },
                          /** 空白をnullにするためにメソッドを経由する */
                          child: Container(
                            width: gredSize,
                            height: gredSize,
                            child: snapShot.data[0][index]
                          ),
                        )
                    );
                  })
              );
            }else{
              return Container();
            }
          });
    });
  }


  dynamic husenOrNull(Widget item, bool mekuriflgs){
    if(item == null){
      return null;
    }else{
      return HusenContainer(
        
        mekuriFlg: mekuriflgs,
        child: item,
      );
    }
  }

  List<dynamic> endNullDelete(List<dynamic> list) {
    /** 末尾のnullを削除 */
    for (int i = list.length - 1; i >= 0; i--) {
      if (list[i] != null) {
        break;
      }
      list.removeAt(i);
    }
    /** 3つ加える(下部に空きスペースを作るため) */
    for (int i = 0; i < 3; i++) {
      list.add(null);
      mekuriflgs.add(false);
      nonflgs.add(true);
    }
    return list;
  }
}