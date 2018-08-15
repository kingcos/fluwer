import 'package:flutter/material.dart';
import 'package:fluwer/page/home_page.dart';

void main() => runApp(new App());

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: const Color(0xFF111111)
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Fluwer", style: new TextStyle(color: Colors.white)),
          iconTheme: new IconThemeData(color: Colors.white)
        ),
        body: new HomePage(),
        drawer: new Drawer(
          child: new Center(
            child: new Text("Drawer"),
          ),
        ),
      ),
    );
  }
}