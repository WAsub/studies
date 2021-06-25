import 'package:flutter/material.dart';
import 'theme/dynamic_theme.dart';
import 'package:tag_memo/reorderableGridView.dart';
import 'package:tag_memo/husenContainer.dart';

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
  double screenHeight;
  double screenWidth;
  double gv;
  @override
  void initState() {
    for (int j = 0; j < 10; j++) {
      lists.add(
        // Text("item${j}")
        Container(alignment: Alignment.center,child: Text("item${j}"),)
        );
    }
    super.initState();
  }

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
        gv = screenWidth / 3;
        // print(lists);
        return ReorderableGridView(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          children: lists,
        );
        // return Container(
        //   // color: Colors.green[100],
        //   child: HusenContainer(),
        // );
      }),
    );
  }
}
