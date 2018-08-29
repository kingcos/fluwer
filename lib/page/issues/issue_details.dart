import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwer/model/jira/jira_issue.dart';

class IssueDetailsPage extends StatefulWidget {
  final JiraIssue jiraIssue;

  IssueDetailsPage({Key key, this.jiraIssue}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new IssueDetailsPageState(jiraIssue: jiraIssue);
  }
}

class IssueDetailsPageState extends State<IssueDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  JiraIssue _jiraIssue;

  IssueDetailsPageState({JiraIssue jiraIssue}) {
    _jiraIssue = jiraIssue;
  }

  @override
  void initState({String jobName}) {
    super.initState();

    _fetchIssueDetails();
  }

  void _fetchIssueDetails() async {
//    var url = Pgyer.API_PREFIX + Pgyer.API_APP_DETAILS;
//    var body = new Map<String, String>();
//
//    body["appKey"] = await Pgyer.fetchAppKey();
//    body["_api_key"] = await Pgyer.fetchAPIKey();
//    body["buildKey"] = _buildKey;
//
//    var data = await Network.post(url: url, body: body);
//
//    if (data == null) {
//      return;
//    }
//
//    setState(() {
//    });
  }

  Future<Null> _pullToRefresh() async {
    setState(() {
      _fetchIssueDetails();
    });
  }

  List<Widget> _buildWidgets() {
    List widgets = new List<Widget>();

    widgets.add(new Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: new Text("Jira issue Info:",
            style:
                new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Summary:'), subtitle: new Text(_jiraIssue.summary)),
    ));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Display name:'),
          subtitle: new Text(_jiraIssue.displayName)),
    ));

    widgets.add(new MergeSemantics(
      child: new ListTile(
          title: new Text('Status name:'),
          subtitle: new Text(_jiraIssue.statusName)),
    ));

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    if (_jiraIssue == null) {
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
          title: new Text(_jiraIssue.summary),
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
