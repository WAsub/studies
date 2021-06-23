import 'package:flutter/material.dart';
import 'package:tag_memo/theme/dynamic_theme.dart';

class ReorderableGridView extends StatefulWidget {
  int crossAxisCount = 3;
  double crossAxisSpacing = 4.0;
  double mainAxisSpacing = 4.0;
  List<Widget> children = [];

  ReorderableGridView({
    Key key,
    this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.children,
  }) : super(key: key);

  @override
  ReorderableGridViewState createState() => ReorderableGridViewState();
}

class ReorderableGridViewState extends State<ReorderableGridView> {
  double wigetWidth;
  double gredSize;
  List<Widget> item;
  bool flg = true;
  
  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(builder: (context, constraints) {
      wigetWidth = constraints.maxWidth;
      gredSize = wigetWidth/3;

      item = widget.children;

      return GridView.count(
        crossAxisCount: widget.crossAxisCount, // 1行の要素数
        crossAxisSpacing: widget.crossAxisSpacing, // 縦スペース
        mainAxisSpacing: widget.mainAxisSpacing, // 横スペース
        children: List.generate(item.length, (index) {
            return GestureDetector(
              // 長押しした時の処理
              onLongPress: () {
                /** 空のアイテムの時は後の入れ替え処理をしないようにする */
                if(item[index] == null){
                  setState(() {
                    flg = false;
                  });
                } 
              },
              // 長押しドラッグで指を離した時の処理
              onLongPressEnd: (LongPressEndDetails  details) {
                /** アイテムが空じゃなかったら入れ替え */
                if(flg){
                  /** スタート時からの差分 */
                  double dx = details.localPosition.dx;
                  double dy = details.localPosition.dy;
                  /** なぜかマイナスの時は+gredSizeされるっぽいので補正 */
                  dx -= dx < 0 ? gredSize : 0;
                  dy -= dy < 0 ? gredSize : 0;
                  /** 移動先index算出 */
                  int moved = 3 * (dy~/gredSize) + (dx~/gredSize); //差分
                  moved += index; // 移動先index
                  setState(() {
                    /** アイテム配列サイズを超えるならnullを入れて拡張 */
                    if(moved > item.length-1){
                      for(int i = item.length-1; i < moved; i++){
                        item.add(null);
                      }
                    }
                    /** 入れ替え */
                    var a = item[moved];
                    item[moved] = item[index];
                    item[index] = a;

                    print(item.length);
                    print(endNullDelete(item));
                  });
                }
              },
          child: item[index],
        );
          }),
        );
      });
  }

  List<dynamic> endNullDelete(List<dynamic> list){
    for(int i = list.length-1; i >= 0; i--){
      if(list[i] != null){
        break;
      }
      list.removeAt(i);
    }
    return list;
  }
}

// class ReorderableGridView extends StatefulWidget{
//   int crossAxisCount = 3;
//   double crossAxisSpacing = 4.0;
//   double mainAxisSpacing = 4.0;
//   ReorderableGridView({
//     this.crossAxisCount,
//     this.crossAxisSpacing,
//     this.mainAxisSpacing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double wigetWidth;
//     double gredSize;

//     return LayoutBuilder(builder: (context, constraints) {
//       wigetWidth = constraints.maxWidth;
//       gredSize = wigetWidth/3;

//         return GridView.count(
//           crossAxisCount: this.crossAxisCount, // 1行の要素数
//           crossAxisSpacing: this.crossAxisSpacing, // 縦スペース
//           mainAxisSpacing: this.mainAxisSpacing, // 横スペース
//           children: List.generate(lists.length, (index) {
            
//             return GestureDetector(
//               // 長押しドラッグで指を離した時の処理
//               onLongPressEnd: (LongPressEndDetails  details) {
//                 // スタート時からの差分
//                 double dx = details.localPosition.dx;
//                 double dy = details.localPosition.dy;
//                 // なぜかマイナスの時は+gvされるっぽいので補正
//                 dx -= dx < 0 ? gredSize : 0;
//                 dy -= dy < 0 ? gredSize : 0;
//                 // 移動先index算出
//                 int moved = 3 * (dy~/gredSize) + (dx~/gredSize); //差分
//                 moved += index;
//                 setState(() {
//                   if(moved > lists.length-1){
//                     for(int i = lists.length-1; i < moved; i++){
//                       lists.add(null);
//                     }
//                   }
//                   var a = lists[moved];
//                   lists[moved] = lists[index];
//                   lists[index] = a;
//                 });
//               },
//               child: lists[index],
//             );
//           }),
          
//         );
//       }),
//   }

// }
