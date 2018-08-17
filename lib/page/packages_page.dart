import 'package:flutter/material.dart';

class PackagesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PackagesPageState();
  }

}

class PackagesPageState extends State<PackagesPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("Packages"),
    );
  }
}