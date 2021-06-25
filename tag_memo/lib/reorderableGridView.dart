import 'package:flutter/material.dart';
import 'package:tag_memo/husenContainer.dart';
import "dart:async";
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
  List<bool> mekuriflgs = [];
  List<bool> nonflgs = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      wigetWidth = constraints.maxWidth;
      gredSize = wigetWidth / 3;

      item = widget.children;
      for(int i = 0; i < item.length; i++){
        mekuriflgs.add(false);
        nonflgs.add(false);
      }

      return GridView.count(
        crossAxisCount: widget.crossAxisCount, // 1行の要素数
        crossAxisSpacing: widget.crossAxisSpacing, // 縦スペース
        mainAxisSpacing: widget.mainAxisSpacing, // 横スペース
        children: List.generate(item.length, (index) {
          return GestureDetector(
            // 長押しした時の処理
            onLongPress: () {
              /** 空のアイテムの時は後の入れ替え処理をしないようにする */
              if (item[index] == null) {
                setState(() {
                  flg = false;
                });
              }
              /** 付箋をめくる */
              setState(() {
                mekuriflgs[index] = true;
              });
            },
            // 長押しドラッグで指を離した時の処理
            onLongPressEnd: (LongPressEndDetails details) async {
              /** アイテムが空じゃなかったら入れ替え */
              if (flg) {
                /** スタート時からの差分 */
                double dx = details.localPosition.dx;
                double dy = details.localPosition.dy;
                /** なんかマイナスの時は+gredSizeされるっぽいので補正 */
                dx -= dx < 0 ? gredSize : 0;
                dy -= dy < 0 ? gredSize : 0;
                /** 移動先index算出 */
                int moved = 3 * (dy ~/ gredSize) + (dx ~/ gredSize); //差分
                moved += index; // 移動先index
                setState(() {
                  /** アイテム配列サイズを超えるならnullを入れて拡張 */
                  if (moved > item.length - 1) {
                    for (int i = item.length - 1; i < moved; i++) {
                      item.add(null);
                      mekuriflgs.add(false);
                      nonflgs.add(true);
                    }
                  }
                  /** 入れ替え */
                  var a = item[moved];
                  item[moved] = item[index];
                  item[index] = a;
                  /** 入れ替える前のところはめくりを戻し、入れ替え先をめくる */
                  mekuriflgs[index] = false;
                  mekuriflgs[moved] = true;
                  /** 末尾の余計なnullを削除 */
                  item = endNullDelete(item);
                });
                /** 一瞬待ってから入れ替え先のめくりを戻す */
                await new Future.delayed(new Duration(milliseconds: 150));
                setState(() {
                  mekuriflgs[moved] = false;
                });
              }
            },
            /** 空白をnullにするためにメソッドを経由する */
            child: husenOrNull(item[index],mekuriflgs[index]),
          );
        }),
      );
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