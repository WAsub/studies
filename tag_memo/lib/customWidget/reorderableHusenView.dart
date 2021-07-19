import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:tag_memo/customWidget/husenContainer.dart';
import "dart:async";

class ReorderableHusenView extends StatefulWidget {
  /** 列の数 */
  int crossAxisCount = 3;
  /** 付箋と付箋の間の隙間 */
  double axisSpacing = 4.0;
  /** アイテム */
  List<Widget> children = [];
  /** 入れ替え後返して欲しい配列データを入れる */
  List<dynamic> keyData = [];
  /** 入れ替え後keyDataを親へ渡す */
  Function(List<dynamic>) callback;

  ReorderableHusenView({
    Key key,
    this.crossAxisCount,
    this.axisSpacing,
    this.children,
    this.keyData,
    this.callback,
  }) : super(key: key);

  @override
  ReorderableHusenViewState createState() => ReorderableHusenViewState();
}

class ReorderableHusenViewState extends State<ReorderableHusenView> {
  final AsyncMemoizer memoizer = AsyncMemoizer();
  /** グリッドビューの高さ */
  double wigetHeight;
  /** グリッドアイテムの大きさ */
  double gredSize;
  /** アイテムのPosition */
  List<Offset> fixedPosition = [];
  List<bool> mekuriflgs = [];
  /** previewに必要なあれこれ */
  bool flg = true;
  Offset startPosition = Offset(0.0, 0.0);
  double top = 0;
  double left = 0;
  Widget previewItem;

  

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
      mekuriflgs = [];
      for(int index = 0; index < widget.children.length; index++){
        fixedPosition.add(Offset(
          (index % widget.crossAxisCount * gredSize) + index % widget.crossAxisCount * widget.axisSpacing, 
          (index ~/ widget.crossAxisCount * gredSize) + index ~/ widget.crossAxisCount * widget.axisSpacing
        ));
        mekuriflgs.add(false);
      }

      /** グリッドビュー */
      return SingleChildScrollView(
          child: Container(
        height: wigetHeight,
        /** プレビュー用アイテムが一番上にするためStackを二重にする */
        child: Stack(children: [
          /** アイテム */
          Stack(
            children: List.generate(widget.children.length, (index) {
              return Positioned(
                  top: fixedPosition[index].dy,
                  left: fixedPosition[index].dx,
                  child: GestureDetector(
                    // onTap: widget.onTap(),
                    onLongPressStart: (LongPressStartDetails details) {
                      /** 空のアイテムの時は後の入れ替え処理をしないようにする */
                      if (widget.children[index] == null){
                        setState(() => flg = false);
                      } 
                      if(flg){
                        setState(() {
                          /** 付箋をめくる */
                          mekuriflgs[index] = true;
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
                    onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
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
                          /** アイテム配列サイズを超えるなら拡張 */
                          if (moved >= widget.children.length) {
                            for (int i = widget.children.length; i <= moved; i++) {
                              widget.children = listAddAt(widget.children, i, null);
                              widget.keyData = listAddAt(widget.keyData, i, null);
                              fixedPosition = listAddAt(fixedPosition, i, Offset((i % widget.crossAxisCount * gredSize) + i % widget.crossAxisCount * widget.axisSpacing, (i ~/ widget.crossAxisCount * gredSize) + i ~/ widget.crossAxisCount * widget.axisSpacing));
                              mekuriflgs = listAddAt(mekuriflgs, i, false);
                            }
                          }
                          /** 入れ替え先の付箋をめくる */
                          mekuriflgs[moved] = true;
                          /** 入れ替え */
                          var cData = widget.keyData[index];
                          widget.children[index] = widget.children[moved];
                          widget.keyData[index] = widget.keyData[moved];
                          widget.children[moved] = previewItem;
                          widget.keyData[moved] = cData;
                          /** 末尾の空白を消す */
                          widget.children = endNullDelete(widget.children);
                          widget.keyData = endNullDelete(widget.keyData);
                          /** プレビュー用アイテムを画面外に飛ばす */
                          previewItem = null;
                          top = -gredSize;
                          left = -gredSize;
                          /** 元の場所付箋のめくりを戻す */
                          mekuriflgs[index] = false;
                        });
                        /** 一瞬待ってから付箋のめくりを戻す */
                        await new Future.delayed(new Duration(milliseconds: 110));
                        setState(() => mekuriflgs[moved] = false);
                        /** keyDataを親に返す */
                        widget.callback(widget.keyData);
                      }
                    },
                    /** アイテム
                     *  うっかりnullを直で突っ込むと無限のサイズが与えられました的なのが出るから
                     *  Containerで囲む */
                    child: Container(
                      width: gredSize, height: gredSize, 
                      color: Colors.transparent,
                      child: husenOrNull(widget.children[index], mekuriflgs[index])
                    ),
                  ));
            }),
          ),
          /** プレビュー用アイテム */
          Positioned(
            top: top,
            left: left,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: previewItem == null ? null : [BoxShadow(
                  color: Colors.black12, 
                  blurRadius: 10.0, 
                  spreadRadius: 1.0, 
                  offset: Offset(5, 5))
                ]), 
              child: HusenContainer(
                mekuriFlg: true,
                child: Container(width: gredSize, height: gredSize, child: previewItem),
              )
            ),
          ),
        ]),
      ));
    });
  }

  dynamic husenOrNull(Widget item, bool mekuriflgs){
    if(item == null){
      return null;
    }else{
      return HusenContainer(
        mekuriFlg: mekuriflgs,
        child: Container(width: gredSize, height: gredSize, child: item),
      );
    }
  }
  List<dynamic> listAddAt(List<dynamic> list, int index, dynamic item) {
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
