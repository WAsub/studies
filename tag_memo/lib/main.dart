import 'package:flutter/material.dart';
import 'theme/dynamic_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          theme: theme,
          home: TagMemo(title: "付箋メモ",),
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

  List<int> lists= [0,1,2,3,4,5,6,7,8,9];
  double deviceHeight;
  double screenHeight;
  double screenWidth;
  double gv; 
  double appb;

  double x = 0;
  double y = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
            screenHeight = constraints.maxHeight;
            screenWidth = constraints.maxWidth;
            gv = screenWidth/3;
            appb = deviceHeight - screenHeight;
            print(size.height);
            print(screenHeight);
            return GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0, // 縦スペース
          mainAxisSpacing: 4.0, // 横スペース
          children: List.generate(lists.length, (index) {
            
            return GestureDetector(
              // ドラッグ中に呼ばれる
              onPanUpdate: (DragUpdateDetails details) {
                print('onPanUpdate - ${details.globalPosition.dy.toString()}');
                // details.globalPosition; //グローバル座標
                // details.localPosition; //ローカル座標
                // details.delta; //前回からの移動量
                setState(() {
                  x = details.globalPosition.dx;
                  y = details.globalPosition.dy - appb;
                });
              },
              onPanStart: (DragStartDetails details) {
                print('onPanStart - ${details.toString()}');
              },
              onPanEnd: (DragEndDetails details) {
                print('onPanEnd - ${details.toString()}');
                print('onPanEnd - ${details.toString()}');
                print('x - ${x.toString()}');
                print('y - ${y.toString()}');
                // setState(() {
                //   lists[]
                // });
              },
              child: Container(
                color: Colors.redAccent[100],
                child: Text(
                  'Item '+ lists[index].toString(),
                ),
              )
            );
          }),
          
        );
      }),
      
      
    );
  }
}
