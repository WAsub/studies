import 'package:flutter/material.dart';
import 'customWidget/reorderableHusenView.dart';
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
            return Text("item${index}");
            // return Container(
            //   color: Colors.transparent,
            //   child: HusenContainer(mekuriFlg: aaa, child: Text("item${index}")),
            // );
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
