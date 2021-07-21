import 'package:flutter/material.dart';
import 'theme/dynamic_theme.dart';
import 'package:tag_memo_sample/customWidget/reorderableGridView.dart';

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
            title: "テストプログラム",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

        return ReorderableGridView(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          children: List.generate(10, (index) {
            return Container(
                alignment: Alignment.center,
                color: Colors.blueGrey,
                child: Text(
                  "$index",
                  style: TextStyle(fontSize: 25),
                ));
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
