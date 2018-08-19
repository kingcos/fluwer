import 'package:flutter/material.dart';

import 'package:fluwer/model/jenkins_job.dart';

import 'package:fluwer/utility/jenkins.dart';
import 'package:fluwer/utility/network.dart';

import 'dart:convert';

class JobsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new JobsPageState();
  }
}

class JobsPageState extends State<JobsPage> {
  var _jobs = [];

  var _scrollController = new ScrollController();

  JobsPageState() {
    fetchJenkinsJobs();
  }

  void fetchJenkinsJobs() async {
    var apiHost = await Jenkins.fetchAPIHost();
    var headers = await Jenkins.fetchRequestHeader();
    var data = await Network.get(apiHost + Jenkins.API_Jobs,headers: headers);

    if (data == null) {
      return;
    }

    var jobs = [];
    for (var jobJSON in json.decode(data)["jobs"]) {
      jobs.add(JenkinsJob.fromJson(jobJSON));
    }

    setState(() {
      _jobs = jobs;
    });
  }

  Widget renderRowAt(int index) {
    if (index.isEven) {
      return new Divider(height: 1.0);
    }

    index = index ~/ 2;

    var jobNameRow = new Row(
      children: <Widget>[new Expanded(child: new Text(_jobs[index].name))],
    );

    return new InkWell(
      child: jobNameRow,
      onTap: () {
        print("$index");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_jobs == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }

    if (_jobs.length == 0) {
      return new Center(
        child: new Text("No Jobs"),
      );
    }

    return new ListView.builder(
        itemCount: _jobs.length * 2,
        itemBuilder: (BuildContext context, int index) {
          return renderRowAt(index);
        },
        controller: _scrollController);
  }
}
