import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_memo/customWidget/husenContainer.dart';

import 'customWidget/deleteDialog.dart';
import 'data/sqlite.dart';
import 'theme/color.dart';
import 'theme/theme_color.dart';

class EditingMemo extends StatefulWidget {
  final int memoId;
  final String title;
  EditingMemo({
    this.memoId = 0,
    this.title = "編集画面",
    Key key,
  }) : super(key: key);
  @override
  EditingMemoState createState() => EditingMemoState();
}

class EditingMemoState extends State<EditingMemo> {
  double deviceHeight;
  double deviceWidth;
  /** リロード時のぐるぐる */
  Widget cpi;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer = AsyncMemoizer();
  /** テーマカラー */
  MaterialColor themeColor = MyColor.rose;
  Map<int, int> colorIndex = {0:50, 1:100, 2:200, 3:300, 4:400, 5:500, 6:600, 7:700, 8:800, 9:900};
  bool colorFlg = false;
  /** メモプレビューリスト */
  Memo _memo = Memo(memoId: -1, memo: "", backColor: 50);
  /** テキストコントローラ */
  TextEditingController controller = TextEditingController();
  /** フォントスタイル */
  Map<String,Color> fontColors = {"ブラック": Colors.black, "ダークグレイ": Colors.black45, "ホワイト": Colors.white};
  double fontSize = 16;
  Color fontColor = Colors.black;

  /** ローディング処理 */
  Future<void> loading() async {
    /** 更新終わるまでグルグルを出しとく */
    setState(() => cpi = CircularProgressIndicator());
    /** テーマカラーを取得 */
    themeColor = await ThemeColor.getBasicAndThemeColor();
    /** メモ取得 */
    if(widget.memoId == 0){
      _memo = Memo(memoId: widget.memoId, memo: "", backColor: 50);
    }else{
      _memo = await SQLite.getMemo(widget.memoId);
    }
    /** メモデータ */
    controller = TextEditingController(text: _memo.memo);
    /** フォント */
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    fontSize = (prefs.getDouble("fontSize") ?? 16.0);
    fontColor = fontColors[(prefs.getString("fontColor") ?? "ブラック")];
    /** グルグル終わり */
    setState(() => cpi = null);
  }

  @override
  void initState() {
    memoizer.runOnce(() async => loading());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          widget.memoId == 0 ? Container() :
          IconButton(
            icon: Icon(Icons.delete), 
            onPressed: () async {
              /** ダイアログ表示 */
              await showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return DeleteDialog(memoId: _memo.memoId,);
                }
              ).then((value) async {
                if(value != "cancel"){
                  Navigator.pop(context,);
                }
              });
            },
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

          return Stack(children: [
            /** メモ帳 */
            Container(
              height: deviceHeight,
              color: themeColor[_memo.backColor],
              padding: EdgeInsets.only(bottom: 48),
              child: new SingleChildScrollView(
                child: SizedBox(
                  height: deviceHeight-48,
                  child: TextField(
                    controller: controller,
                    style: TextStyle(fontSize: fontSize, color: fontColor),
                    maxLines: 500,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'メモを書く',
                      hintStyle: TextStyle(color: Colors.black26)
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ),
            /** 下部のアクションバー */
            Positioned(
              bottom: 0,
              child: Container(
                height: 56,
                width: deviceWidth,
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    setState(() => colorFlg = false);
                  },
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                    /** 保存ボタン */
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.check),
                      backgroundColor: Theme.of(context).accentColor,
                      onPressed: () async {
                        _memo.memo = controller.text == null ? "" : controller.text;
                        if(_memo.memoId == 0){
                          await SQLite.insertMemo(_memo);
                        }else{
                          await SQLite.updateMemo(_memo);
                        }
                        Navigator.pop(context,);
                      },
                    ),
                    bottomNavigationBar: BottomAppBar(
                      color: Theme.of(context).primaryColor,
                      notchMargin: 5.0,
                      shape: AutomaticNotchedShape(
                        RoundedRectangleBorder(),
                        StadiumBorder(
                          side: BorderSide(),
                        ),
                      ),
                      child: Row(children: [
                        /** 付箋の色選択ON/OFF */
                        IconButton(
                          icon: Icon(Icons.format_color_fill, color: Theme.of(context).selectedRowColor,),
                          onPressed: () => setState(() => colorFlg = colorFlg ? false : true)
                        ),
                      ]),
                    ),
                  ),
                )
              )
            ),
            /** 付箋の色選択 */
            colorFlg ? Positioned(
              left: 5,
              bottom: 53,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(153),
                  border: Border.all(width: 1.5,color: Theme.of(context).selectedRowColor)
                ),
                height: 112, width: 290,
                padding: EdgeInsets.all(10),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: List.generate(5, (index){
                      Color color = themeColor[colorIndex[index]];
                      HSVColor backSide = HSVColor.fromColor(color);
                      return GestureDetector(
                        onTap: () => setState(() => _memo.backColor = colorIndex[index]),
                        child: HusenContainer(
                          height: 40,width: 40, 
                          color: color,
                          backSideColor: backSide.withValue(backSide.value-0.15).toColor(),
                        ),
                      );
                    })
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index){
                      Color color = themeColor[colorIndex[index+5]];
                      HSVColor backSide = HSVColor.fromColor(color);
                      return GestureDetector(
                        onTap: () => setState(() => _memo.backColor = colorIndex[index+5]),
                        child: HusenContainer(
                          height: 40,width: 40, 
                          color: color,
                          backSideColor: backSide.withValue(backSide.value-0.15).toColor(),
                        ),
                      );
                    })
                  ),
                ],),
              )
            ) : Container(),
            /** ロード */
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 10),
              child: Container(
                alignment: Alignment.topCenter,
                width: 25, height: 25,
                child: cpi,
              )
            )
          ],);
      }),
    );
  }
}
