import 'package:flutter/material.dart';

import 'customTile.dart';

class DropdownTile extends StatelessWidget {
  String title;
  String value;
  List<String> items;
  void Function(String) onChanged;
  
  DropdownTile({
    this.title = "",
    this.value,
    this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    this.items = this.items == null ? [] : this.items;
    this.onChanged = this.onChanged == null ? (newValue){} : this.onChanged;

      return LayoutBuilder(builder: (context, constraints) {
        return CustomTile(
          title: Text(this.title, style: TextStyle(fontSize: 16),),
          trailing: DropdownButton<String>(
            icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).accentColor,),
            iconSize: 22,
            underline: Container(
              height: 2,
              color: Theme.of(context).accentColor,
            ),
            value: this.value,
            items: this.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) async {
              this.onChanged(newValue);
            },
          ),
        );
      });
  }
}
