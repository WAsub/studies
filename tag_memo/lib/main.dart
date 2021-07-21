import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tag_memo/customWidget/husenContainer.dart';
import 'package:tag_memo/data/sqlite.dart';
import 'package:tag_memo/editingMemo.dart';
import 'package:tag_memo/theme/color.dart';
import 'customWidget/customText.dart';
import 'customWidget/reorderableHusenView.dart';
import 'theme/dynamic_theme.dart';
import 'theme/theme_color.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,//縦固定
  ]);
  //runApp
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          theme: theme,
          home: TagMemo(
            title: "付箋メモ",
          ),
        );
      },
    );
  }
}

class TagMemo extends StatefulWidget {
  TagMemo({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TagMemoState createState() => _TagMemoState();
}

class _TagMemoState extends State<TagMemo> {
  double deviceHeight;
  double deviceWidth;
  /** リロード時のぐるぐる */
  Widget cpi;
  /** 初期化を一回だけするためのライブラリ */
  final AsyncMemoizer memoizer = AsyncMemoizer();
  /** テーマカラー */
  MaterialColor themeColor = MyColor.rose;
  /** メモプレビューリスト */
  List<Memo> _previewList = [];

  /** ローディング処理 */
  Future<void> loading() async {
    /** 更新終わるまでグルグルを出しとく */
    setState(() => cpi = CircularProgressIndicator());
    /** テーマカラーを取得 */
    themeColor = await ThemeColor.getThemeColor();
    /** プレビューリスト取得 */
    _previewList = await SQLite.getMemoPreview();
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
    /** 画面 */
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

        return Stack(children: [
            ReorderableHusenView(
              crossAxisCount: 3,
              axisSpacing: 6.0,
              callback: (colors, callbacData) async {
                List<int> memoIds = [];
                for(Memo cblist in callbacData){
                  if(cblist == null){
                    memoIds.add(0);
                  }else{
                    memoIds.add(cblist.memoId);
                  }
                }
                await SQLite.renewMemoOrder(memoIds);
                loading();
              },
              colors: List.generate(_previewList.length, (index) {
                /** 空白ならnull */
                if(_previewList[index] == null){ return null;}
                /** アイテムがあるなら色をセット */
                Color color = themeColor[_previewList[index].backColor];
                Color backSide = Color.fromARGB(255, color.red-50, color.green-50, color.blue-50);
                return HusenColor(color: color, backSideColor: backSide);
              }),
              children: List.generate(_previewList.length, (index) {
                /** 空白ならnull */
                if(_previewList[index] == null){
                  return null;
                }
                /** アイテムがあるならプレビュー表示 */
                return GestureDetector(
                  onTap: (){
                    print("hello${index}");
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) {
                    //     // メモ編集画面へ
                    //     return EditingMemo();
                    //   }),
                    // ).then((value) async {
                      
                    // });
                  },
                  child: CustomText(
                    _previewList[index].memoPreview,
                    overflow: TextOverflow.ellipsis, maxLines: 5,
                  )
                );
              }),
              callbackData: _previewList,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
