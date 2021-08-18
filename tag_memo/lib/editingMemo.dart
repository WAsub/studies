import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  /** メモプレビューリスト */
  Memo _memo;
  /** テキストコントローラ */
  TextEditingController controller = TextEditingController();
  /** 付箋色 */
  Color backColor = Colors.white;
  Color nextColor = Colors.white;
  /** フォントスタイル */
  Map<String,Color> fontColors = {"ブラック": Colors.black, "ダークグレイ": Colors.black45, "ホワイト": Colors.white};
  double fontSize = 16;
  Color fontColor = Colors.black;
  int next(int index){
    int nextIndex = (((index + 100) ~/ 100) % 10) * 100;
    if(nextIndex==0){
      return 50;
    }
    return nextIndex;
  }

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
    /** カラー */
    backColor = themeColor[_memo.backColor];
    nextColor = themeColor[next(_memo.backColor)];
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
              await SQLite.deleteMemo(_memo.memoId);
              Navigator.pop(context,);
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
              color: backColor,
              padding: EdgeInsets.only(bottom: 48),
              child: new SingleChildScrollView(
                child: SizedBox(
                  height: deviceHeight-48,
                  child: new TextField(
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
                  onTap: () => FocusScope.of(context).unfocus(),
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
                      child: new Row(children: [
                        /** 付箋の色を変えるボタン */
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            side: BorderSide(
                              color: nextColor, // 次の色
                              width: 5,
                              style: BorderStyle.solid,
                            ),
                            shape: CircleBorder(),
                          ),
                          child: null,
                          onPressed: (){
                            setState(() {
                              _memo.backColor = next(_memo.backColor);
                              backColor = themeColor[_memo.backColor];
                              nextColor = themeColor[next(_memo.backColor)];
                            });
                          }, 
                        ),
                      ]),
                    ),
                  ),
                )
              )
            ),
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
