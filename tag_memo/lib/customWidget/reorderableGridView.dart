import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:tag_memo/customWidget/husenContainer.dart';
import "dart:async";

// ignore: must_be_immutable
class ReorderableGridView extends StatefulWidget {
  /// 列の数
  final int crossAxisCount;
  /// 付箋と付箋の間の隙間
  final double axisSpacing;
  /// アイテム
  List<Widget> children = [];
  /// 入れ替え後返して欲しい配列データを入れる。キーとか
  List<dynamic> callbackData = [];
  /// 入れ替え後callbackDataを親へ渡す
  Function(List<dynamic>) callback;
  /// ジェスチャー類
  Function(int index) onTap;
  Function(int index, LongPressStartDetails details) onLongPressStart;
  Function(int index, LongPressMoveUpdateDetails details) onLongPressMoveUpdate;
  Function(int index, int moved, LongPressEndDetails details) onLongPressEnd;

  ReorderableGridView({
    this.crossAxisCount = 3,
    this.axisSpacing = 4.0,
    @required this.children,
    @required this.callbackData,
    this.callback,
    this.onTap,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
  });

  @override
  ReorderableGridViewState createState() => ReorderableGridViewState();
}

class ReorderableGridViewState extends State<ReorderableGridView> {
  final AsyncMemoizer memoizer = AsyncMemoizer();
  /// グリッドビューの高さ
  double wigetHeight;
  /// グリッドアイテムの大きさ
  double gredSize;
  /// アイテムのPosition
  List<Offset> fixedPosition = [];
  /// previewに必要なあれこれ
  bool flg = true;
  Offset startPosition = Offset(0.0, 0.0);
  double top = 0;
  double left = 0;
  Widget previewItem;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      /** グリッドサイズ */
      gredSize = (constraints.maxWidth - widget.axisSpacing * (widget.crossAxisCount - 1)) / widget.crossAxisCount;
      /** 余裕をもってスクロールできるように設定 */
      wigetHeight = ((widget.children.length ~/ widget.crossAxisCount * gredSize) + widget.children.length ~/ widget.crossAxisCount * widget.axisSpacing) + gredSize * 2;
      /** ウィジェットのHeightより小さかったらウィジェットのHeightに変える */
      wigetHeight = wigetHeight < constraints.maxHeight ? constraints.maxHeight : wigetHeight;
      /** SetState時に再設定されるとおかしくなるので最初の一回だけ設定 */
      memoizer.runOnce(() async {
        /** プレビュー用アイテムを画面外に飛ばす */
        top = -gredSize;
        left = -gredSize;
      });
      /** 各アイテムのPositionを設定 */
      fixedPosition = [];
      for (int index = 0; index < widget.children.length; index++) {
        fixedPosition.add(Offset(
          (index % widget.crossAxisCount * gredSize) + index % widget.crossAxisCount * widget.axisSpacing, 
          (index ~/ widget.crossAxisCount * gredSize) + index ~/ widget.crossAxisCount * widget.axisSpacing
        ));
      }
      /** グリッドビュー */
        return SingleChildScrollView(
          child: Container(
            height: wigetHeight,
            /** プレビュー用アイテムが一番上にするためStackを二重にする */
            child: Stack(children: [
              /** アイテム */
              Stack(children: List.generate(widget.children.length, (index) {
                return Positioned(
                  top: fixedPosition[index].dy,
                  left: fixedPosition[index].dx,
                  child: GestureDetector(
                    onTap: (){
                      widget.onTap(index);
                    },
                    onLongPressStart: (LongPressStartDetails details) async {
                      /** 空のアイテムの時は後の入れ替え処理をしないようにする */
                      if (widget.children[index] == null){
                        setState(() => flg = false);
                      } 
                      if(flg){
                        setState(() {
                          /** 指の位置によってtopとleftを補正 */
                          startPosition = details.localPosition;
                          top = fixedPosition[index].dy + details.localPosition.dy - startPosition.dy;
                          left = fixedPosition[index].dx + details.localPosition.dx - startPosition.dx;
                          /** プレビュー用アイテムに移動するアイテムを入れて */
                          previewItem = widget.children[index];
                          /** 元の場所は見えないようにする */
                          widget.children[index] = null;
                        });
                      }
                    },
                    onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) async {
                      if(flg){
                        setState(() {
                          top = fixedPosition[index].dy + details.localPosition.dy - startPosition.dy;
                          left = fixedPosition[index].dx + details.localPosition.dx - startPosition.dx;
                        });
                      }
                    },
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
                        int moved = widget.crossAxisCount * (dy ~/ gredSize) + (dx ~/ gredSize); //差分
                        moved += index; // 移動先index
                        setState(() {
                          /** アイテム配列サイズを超えるならnullを入れて拡張 */
                          if (moved >= widget.children.length) {
                            for (int i = widget.children.length; i <= moved; i++) {
                              widget.children = listAddAt(widget.children, i, null);
                              widget.callbackData = listAddAt(widget.callbackData, i, null);
                              fixedPosition = listAddAt(fixedPosition, i, Offset((i % widget.crossAxisCount * gredSize) + i % widget.crossAxisCount * widget.axisSpacing, (i ~/ widget.crossAxisCount * gredSize) + i ~/ widget.crossAxisCount * widget.axisSpacing));
                            }
                          }
                          /** 入れ替え */
                          var cData = widget.callbackData[index];
                          widget.children[index] = widget.children[moved];
                          widget.callbackData[index] = widget.callbackData[moved];
                          widget.children[moved] = previewItem;
                          widget.callbackData[moved] = cData;
                          /** 末尾の空白を消す */
                          widget.children = endNullDelete(widget.children);
                          widget.callbackData = endNullDelete(widget.callbackData);
                          /** プレビュー用アイテムを画面外に飛ばす */
                          previewItem = null;
                          top = -gredSize;
                          left = -gredSize;
                        });
                        /** callbackDataを親に返す */
                        widget.callback(widget.callbackData);
                      }
                    },
                    /** アイテム */
                    child: Container(width: gredSize, height: gredSize, child: widget.children[index]),
                  )
                );
              })),
              /** プレビュー用アイテム */
              Positioned(
                top: top,
                left: left,
                child: Container(
                  height: gredSize, width: gredSize, 
                  decoration: BoxDecoration(
                    boxShadow: previewItem == null ? null : [BoxShadow(
                      color: Colors.black12, 
                      blurRadius: 10.0, 
                      spreadRadius: 1.0, 
                      offset: Offset(5, 5)
                    )]), 
                  child: previewItem
                ),
              ),
            ]),
          )
        );
    });
  }

  static List<dynamic> listAddAt(List<dynamic> list, int index, dynamic item) {
    /** アイテム配列サイズを超えるならnullを入れて拡張 */
    if (index >= list.length) {
      for (int i = list.length; i <= index; i++) {
        list.add(null);
      }
    }
    list[index] = item;
    return list;
  }

  List<dynamic> endNullDelete(List<dynamic> list) {
    /** 末尾のnullを削除 */
    for (int i = list.length - 1; i >= 0; i--) {
      if (list[i] != null) {
        break;
      }
      list.removeAt(i);
    }
    return list;
  }
}
