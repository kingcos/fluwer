import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluwer/model/jenkins_job.dart';
import 'package:fluwer/page/jobs/job_details.dart';
import 'package:fluwer/utility/constants.dart';
import 'package:fluwer/utility/jenkins.dart';
import 'package:fluwer/utility/network.dart';

class JobsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new JobsPageState();
  }
}

class JobsPageState extends State<JobsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  int _currentPage;

  List _jobs;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _currentPage = 1;
    _scrollController = new ScrollController();

    _fetchJenkinsJobs();

    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;

      if (maxScroll == pixels) {
        _currentPage += 1;

        setState(() {
          _refreshIndicatorKey.currentState.show();

          _fetchJenkinsJobs();
        });
      }
    });
  }

  void _fetchJenkinsJobs({int perPage = 5}) async {
    var startIndex = (_currentPage - 1) * perPage;
    var endIndex = _currentPage * perPage;
    var params = new Map<String, String>();
    params["tree"] =
        "jobs" + Uri.encodeQueryComponent("[name]{$startIndex,$endIndex}");

    var url = await Jenkins.fetchAPIHost() + Jenkins.API_JSON_SUFFIX;
    var headers = await Jenkins.fetchRequestHeader();
    var data = await Network.get(url: url, params: params, headers: headers);

    if (data == null) {
      return;
    }

    if (_jobs == null) {
      _jobs = new List<JenkinsJob>();
    }

    setState(() {
      for (var jobJSON in json.decode(data)["jobs"]) {
        _jobs.add(JenkinsJob.fromJSON(jobJSON));
      }
    });
  }

  Future<Null> _pullToRefresh() async {
    _jobs = null;
    _currentPage = 1;

    setState(() {
      _fetchJenkinsJobs();
    });
  }

  Widget _rowAt(int index) {
    if (index.isEven) {
      return new Divider(height: 1.0);
    }

    index = index ~/ 2;

    var jobNameRow = new Row(
      children: <Widget>[
        new Expanded(
            child: new Padding(
          padding: const EdgeInsets.all(15.0),
          child:
              new Text(_jobs[index].name, style: new TextStyle(fontSize: 50.0)),
        ))
      ],
    );

    return new InkWell(
      child: jobNameRow,
      onTap: () {
        Navigator
            .of(context)
            .push(new MaterialPageRoute(builder: (BuildContext context) {
          return new JobDetailsPage(name: _jobs[index].name);
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_jobs == null) {
      return new Center(child: new CircularProgressIndicator());
    }

    if (_jobs.length == 0) {
      return new Center(
        child: new Text(
          Constants.NO_DATA_PLACEHOLDER,
          style: new TextStyle(fontSize: 22.0),
          textAlign: TextAlign.center,
        ),
      );
    }

    return new Scaffold(
      body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          child: new ListView.builder(
              itemCount: _jobs.length * 2,
              itemBuilder: (BuildContext context, int index) {
                return _rowAt(index);
              },
              controller: _scrollController),
          onRefresh: _pullToRefresh),
    );
  }
}
