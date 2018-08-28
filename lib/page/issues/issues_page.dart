import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluwer/model/jira/jira_filter.dart';
import 'package:fluwer/utility/jira.dart';
import 'package:fluwer/utility/network.dart';

class IssuesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IssuesPageState();
  }
}

class IssuesPageState extends State<IssuesPage> {
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

    setState(() {
//      for (var jobJSON in json.decode(data)["jobs"]) {
//        _jobs.add(JenkinsJob.fromJSON(jobJSON));
//      }
    });
  }

  Future<Null> _pullToRefresh() async {
    setState(() {
      _fetchIssuesFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("Issues"),
    );
  }
}
