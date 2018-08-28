import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwer/model/pgyer/pgyer_app.dart';
import 'package:fluwer/utility/network.dart';
import 'package:fluwer/utility/pgyer.dart';

class PackageDetailsPage extends StatefulWidget {
  final String buildKey;

  PackageDetailsPage({Key key, this.buildKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PackageDetailsPageState(buildKey: buildKey);
  }
}

class PackageDetailsPageState extends State<PackageDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _buildKey;
  PgyerApp _pgyerApp;

  PackageDetailsPageState({String buildKey}) {
    _buildKey = buildKey;
  }

  @override
  void initState({String jobName}) {
    super.initState();

    _fetchPackageDetails();
  }

  void _fetchPackageDetails() async {
    var url = Pgyer.API_PREFIX + Pgyer.API_APP_DETAILS;
    var body = new Map<String, String>();

    body["appKey"] = await Pgyer.fetchAppKey();
    body["_api_key"] = await Pgyer.fetchAPIKey();
    body["buildKey"] = _buildKey;

    var data = await Network.post(url: url, body: body);

    if (data == null) {
      return;
    }

    setState(() {
      var pgyerAppJSON = json.decode(data)["data"];
      print(pgyerAppJSON);
      _pgyerApp = PgyerApp.fromJSON(pgyerAppJSON);
    });
  }

  Future<Null> _pullToRefresh() async {
    setState(() {
      _fetchPackageDetails();
    });
  }

  List<Widget> _buildWidgets() {
    List widgets = new List<Widget>();

    widgets.add(new Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: new Text("Pgyer Info:",
            style:
                new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))));

    widgets.add(Image.network(Pgyer.API_APP_ICON_PREFIX + _pgyerApp.buildIcon,
        width: 100.0, height: 100.0));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Build name:'),
          subtitle: new Text(_pgyerApp.buildName)),
    ));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Build password (Long press to copy):'),
          subtitle: new Text(_pgyerApp.buildPassword),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _pgyerApp.buildPassword));
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text("Copied to Clipboard"),
            ));
          }),
    ));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Build version:'),
          subtitle: new Text(_pgyerApp.buildVersion)),
    ));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Build version number:'),
          subtitle: new Text(_pgyerApp.buildVersionNo)),
    ));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Build update description:'),
          subtitle: new Text(_pgyerApp.buildUpdateDescription)),
    ));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Build created:'),
          subtitle: new Text(_pgyerApp.buildCreated)),
    ));

    widgets.add(
        Image.network(_pgyerApp.buildQRCodeURL, width: 300.0, height: 300.0));

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    if (_pgyerApp == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Fluwer"),
        ),
        body: new Center(child: new CircularProgressIndicator()),
      );
    }

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(_pgyerApp.buildName),
        ),
        body: new RefreshIndicator(
            child: new DecoratedBox(
              decoration: const BoxDecoration(color: const Color(0xFFEFEFF4)),
              child: new ListView(
                children: _buildWidgets(),
              ),
            ),
            onRefresh: _pullToRefresh));
  }
}
