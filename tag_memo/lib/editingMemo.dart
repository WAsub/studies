import 'package:flutter/material.dart';

class EditingMemo extends StatefulWidget {

  EditingMemo({

    Key key,
  }) : super(key: key);
  @override
  EditingMemoState createState() => EditingMemoState();
}

class EditingMemoState extends State<EditingMemo> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,height: 400,);
  }
}