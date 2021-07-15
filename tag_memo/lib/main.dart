import 'package:flutter/material.dart';
import 'package:tag_memo/customWidget/husenContainer.dart';
import 'package:tag_memo/customWidget/reorderableGridView2.dart';
import 'theme/dynamic_theme.dart';
import 'package:tag_memo/customWidget/reorderableGridView.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

        return ReorderableGridView2(
          crossAxisCount: 3,
          axisSpacing: 4.0,
          children: List.generate(10, (index) {
            return HusenContainer(child: Text("item${index}"));
          }),
        );
        // return ReorderableGridView(
        //   crossAxisCount: 3,
        //   crossAxisSpacing: 4.0,
        //   mainAxisSpacing: 4.0,
        //   children: List.generate(10, (index) {
        //     return Container(alignment: Alignment.center,child: Text("item${index}"));
        //   }),
        // );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          
        },
      ),
    );
  }
}
