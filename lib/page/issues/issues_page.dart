import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluwer/model/jira/jira_filter.dart';
import 'package:fluwer/model/jira/jira_issue.dart';
import 'package:fluwer/utility/constants.dart';
import 'package:fluwer/utility/jira.dart';
import 'package:fluwer/utility/network.dart';

class IssuesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IssuesPageState();
  }
}

class IssuesPageState extends State<IssuesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List _issues;

  @override
  void initState({String jobName}) {
    super.initState();

    _fetchIssuesFilter().then((issueURL) => _fetchIssues(issueURL: issueURL));
  }

  Future<String> _fetchIssuesFilter() async {
    var url = await Jira.fetchAPIHost() +
        Jira.API_PREFIX +
        Jira.API_FILTER +
        await Jira.fetchFilterID();
    var headers = await Jira.fetchRequestHeader();
    var data = await Network.get(url: url, headers: headers);

    if (data == null) {
      return "";
    }

    return JiraFilter.fromJSON(json.decode(data)).searchUrl;
  }

  void _fetchIssues({String issueURL}) async {
    if (issueURL == "") {
      return;
    }

    var headers = await Jira.fetchRequestHeader();
    var data = await Network.get(url: issueURL, headers: headers);

    if (data == null) {
      return;
    }

    if (_issues == null) {
      _issues = new List<JiraIssue>();
    }

    setState(() {
      for (var issueJSON in json.decode(data)["issues"]) {
        _issues.add(JiraIssue.fromJSON(issueJSON));
      }
    });
  }

  Future<Null> _pullToRefresh() async {
    _issues = null;

    setState(() {
      _fetchIssuesFilter().then((issueURL) => _fetchIssues(issueURL: issueURL));
    });
  }

  Widget _rowAt(int index) {
    if (index.isEven) {
      return new Divider(height: 1.0);
    }

    index = index ~/ 2;

    var issueRow = new MergeSemantics(
        child: new ListTile(
      title: new Text(_issues[index].summary),
      subtitle: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(_issues[index].displayName),
          new Text(_issues[index].statusName)
        ],
      ),
    ));

    return new InkWell(
        child: issueRow,
        onTap: () {
//        Navigator
//            .of(context)
//            .push(new MaterialPageRoute(builder: (BuildContext context) {
//          return new JobDetailsPage(name: _jobs[index].name);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_issues == null) {
      return new Center(child: new CircularProgressIndicator());
    }

    if (_issues.length == 0) {
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
              itemCount: _issues.length * 2,
              itemBuilder: (BuildContext context, int index) {
                return _rowAt(index);
              }),
          onRefresh: _pullToRefresh),
    );
  }
}
