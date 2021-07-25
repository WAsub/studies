import 'package:async/async.dart';
import 'package:flutter/material.dart';

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
    themeColor = await ThemeColor.getThemeColor();
    /** メモ取得 */
    _memo = await SQLite.getMemo(widget.memoId);
    controller = TextEditingController(text: _memo.memo);
    backColor = themeColor[_memo.backColor];
    nextColor = themeColor[next(_memo.backColor)];
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
      appBar: AppBar(title: Text(widget.title)),
      body: LayoutBuilder(builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;

          return Stack(children: [
            Container(
              height: deviceHeight,
              color: backColor,
              padding: EdgeInsets.only(bottom: 48),
              child: new SingleChildScrollView(
                child: SizedBox(
                  height: deviceHeight-48,
                  child: new TextField(
                    controller: controller,
                    maxLines: 500,
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Theme.of(context).accentColor,
                      ),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Theme.of(context).accentColor,
                      ),),
                      border: InputBorder.none,
                      hintText: 'Add your text here',
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ),
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
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.check),
                      backgroundColor: Theme.of(context).accentColor,
                      onPressed: () {},
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
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: nextColor,
                                width: 5,
                                style: BorderStyle.solid,
                              ),
                              shape: CircleBorder(),
                            ),
                            child: null,
                            onPressed: (){}, 
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
