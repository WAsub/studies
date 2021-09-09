import 'package:flutter/material.dart';
import 'package:tag_memo/data/sqlite.dart';

class DeleteDialog extends StatefulWidget {
  final int memoId;
  DeleteDialog({
    this.memoId = 0,
    Key key,
  }) : super(key: key);
  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;
            return Container(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: deviceHeight * 0.35,
                width: deviceWidth * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("付箋を削除しますか？", style: TextStyle(color: Colors.black54)),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(
                        top: deviceHeight * 0.35 * 0.3, 
                        bottom: 10,
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ボタン領域
                          FlatButton(
                            minWidth: 110,
                            color: Theme.of(context).primaryColor,
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("キャンセル", style: TextStyle(color: Colors.white)),
                            onPressed: () => Navigator.pop(context, "cancel"),
                          ),
                          FlatButton(
                            minWidth: 110,
                            color: Theme.of(context).accentColor,
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("削除", style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              await SQLite.deleteMemo(widget.memoId);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    )
                  ],
                )
              ),
            );
        })
      );
  }
}