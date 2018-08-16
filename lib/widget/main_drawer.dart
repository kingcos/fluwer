import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: const BoxConstraints.expand(width: 300.0),
      child: new Material(
        elevation: 16.0,
        child: new Container(
          decoration: new BoxDecoration(
            color: const Color(0xFFFFFFFFFF),
          ),
          child: new ListView.builder(
            itemCount: 5 * 2 + 1,
            itemBuilder: renderRow,
          ),
        ),
      ),
    );
  }

  Widget renderRow(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        width: 300.0,
        height: 100.0,
        color: Colors.red,
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new Text("Test"),
      );
    }

    index -= 1;

    if (index.isOdd) {
      return new Divider();
    }

    index = index ~/ 2;

    var listItems = new Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: new Row(
        children: <Widget>[
          new Expanded(child: new Text("$index")),
        ],
      ),
    );
    
    return new InkWell(
      child: listItems,
      onTap: () {
        print("Click $index");
      },
    );
  }
}