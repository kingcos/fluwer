import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:fluwer/page/issues_page.dart';
import 'package:fluwer/page/jobs_page.dart';
import 'package:fluwer/page/packages_page.dart';
import 'package:fluwer/page/settings_page.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(new App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  var _tabBarIndex = 0;
  var _body;

  // 初始化
  init() {
    _body = new IndexedStack(
      children: <Widget>[
        new JobsPage(),
        new PackagesPage(),
        new IssuesPage(),
        new SettingsPage()
      ],
      index: _tabBarIndex,
    );
  }

  // Tab Bar 子项
  List<BottomNavigationBarItem> tabBarItems() {
    const tabBarTitles = ["Jobs", "Packages", "Issues", "Settings"];
    const tabBarIcons = [
      ["lib/image/jobs.png", "lib/image/jobs_selected.png"],
      ["lib/image/packages.png", "lib/image/packages_selected.png"],
      ["lib/image/issues.png", "lib/image/issues_selected.png"],
      ["lib/image/settings.png", "lib/image/settings_selected.png"],
    ];

    var list = new List<BottomNavigationBarItem>();

    for (var i = 0; i < tabBarTitles.length; i++) {
      var iconName;
      if (i == _tabBarIndex) {
        iconName = tabBarIcons[i][1];
      } else {
        iconName = tabBarIcons[i][0];
      }

      list.add(new BottomNavigationBarItem(
        icon: new Image.asset(iconName, width: 25.0, height: 25.0),
        title: new Text(tabBarTitles[i],
            style: new TextStyle(color: const Color(0xFF111111))),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    init();

    return new MaterialApp(
      theme: new ThemeData(
          primaryColor: const Color(0xFF111111), fontFamily: ".SF UI Text"),
      home: new Scaffold(
        appBar: new AppBar(
            title:
                new Text("Fluwer", style: new TextStyle(color: Colors.white)),
            iconTheme: new IconThemeData(color: Colors.white)),
        body: _body,
        bottomNavigationBar: new CupertinoTabBar(
          items: tabBarItems(),
          currentIndex: _tabBarIndex,
          onTap: (index) {
            setState(() {
              _tabBarIndex = index;
            });
          },
        ),
      ),
    );
  }
}
