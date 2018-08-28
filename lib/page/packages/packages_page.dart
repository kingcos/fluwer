import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluwer/model/pgyer/pgyer_build.dart';
import 'package:fluwer/utility/constants.dart';
import 'package:fluwer/utility/network.dart';
import 'package:fluwer/utility/pgyer.dart';

class PackagesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PackagesPageState();
  }
}

class PackagesPageState extends State<PackagesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _currentPage;
  List _packages;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _currentPage = 1;
    _scrollController = new ScrollController();

    _fetchPgyerPackages();

    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;

      if (maxScroll == pixels) {
        _currentPage += 1;

        setState(() {
          _fetchPgyerPackages();

          _scaffoldKey.currentState.showSnackBar(const SnackBar(
              content: const Text(Constants.LOADING_PLACEHOLDER)));
        });
      }
    });
  }

  void _fetchPgyerPackages() async {
    var url = Pgyer.API_PREFIX + Pgyer.API_APP_ALL_BUILDS;
    var body = new Map<String, String>();

    body["appKey"] = await Pgyer.fetchAppKey();
    body["_api_key"] = await Pgyer.fetchAPIKey();
    body["page"] = _currentPage.toString();

    var data = await Network.post(url: url, body: body);

    if (data == null) {
      return;
    }

    print(data);

    if (_packages == null) {
      _packages = new List<PgyerBuild>();
    }

    setState(() {
      for (var packageJSON in json.decode(data)["data"]["list"]) {
        _packages.add(PgyerBuild.fromJSON(packageJSON));
      }
    });
  }

  Future<Null> _pullToRefresh() async {
    _packages = null;
    _currentPage = 1;

    setState(() {
      _fetchPgyerPackages();
    });
  }

  Widget _rowAt(int index) {
    if (index.isEven) {
      return new Divider(height: 1.0);
    }

    index = index ~/ 2;

//    var jobNameRow = new Row(
//      children: <Widget>[
//        new Expanded(
//            child: new Padding(
//          padding: const EdgeInsets.all(15.0),
//          child: new Text(_packages[index].buildVersionNo,
//              style: new TextStyle(fontSize: 20.0)),
//        ))
//      ],
//    );

    var jobNameRow = new Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.network(
                Pgyer.API_APP_ICON_PREFIX + _packages[index].buildIcon,
                width: 100.0,
                height: 100.0),
            new Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_packages[index].buildName,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  new Row(
                    children: <Widget>[
                      const Text("Version: ",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      new Text(_packages[index].buildVersion)
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      const Text("Version No: ",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      new Text(_packages[index].buildVersionNo)
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      const Text("Update note: ",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      new Text(_packages[index].buildUpdateDescription)
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      const Text("Created at: ",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      new Text(_packages[index].buildCreated)
                    ],
                  )
                ],
              ),
            )
          ],
        ));

    return new InkWell(
      child: jobNameRow,
      onTap: () {
//        Navigator
//            .of(context)
//            .push(new MaterialPageRoute(builder: (BuildContext context) {
//          return new JobDetailsPage(name: _packages[index].name);
//        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_packages == null) {
      return new Center(child: new CircularProgressIndicator());
    }

    if (_packages.length == 0) {
      return new Center(
        child: new Text(
          Constants.NO_DATA_PLACEHOLDER,
          style: new TextStyle(fontSize: 22.0),
          textAlign: TextAlign.center,
        ),
      );
    }

    return new Scaffold(
      key: _scaffoldKey,
      body: new RefreshIndicator(
          child: new ListView.builder(
              itemCount: _packages.length * 2,
              itemBuilder: (BuildContext context, int index) {
                return _rowAt(index);
              },
              controller: _scrollController),
          onRefresh: _pullToRefresh),
    );
  }
}
