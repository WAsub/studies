import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tag_memo/editingMemo.dart';
import 'customWidget/reorderableHusenView.dart';
import 'theme/dynamic_theme.dart';

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
  List<Widget> lists = [];
  double deviceHeight;
  double deviceWidth;
  bool aaa = true;
  @override
  void initState() {
    for (int j = 0; j < 10; j++) {
      lists.add(
          // Text("item${j}")
          Container(
        alignment: Alignment.center,
        child: Text("item${j}"),
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

        return ReorderableHusenView(
          crossAxisCount: 4,
          axisSpacing: 6.0,
          children: List.generate(10, (index) {
            // return Text("item${index}");
            return GestureDetector(
              onTap: (){
                print("hello${index}");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // メモ編集画面へ
                    return EditingMemo();
                  }),
                ).then((value) async {
                  
                });
              },
              child: Text("item${index}"),
            );
          }),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
