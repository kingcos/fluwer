import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluwer/model/jenkins_job.dart';
import 'package:fluwer/page/jobs/job_details.dart';
import 'package:fluwer/utility/jenkins.dart';
import 'package:fluwer/utility/network.dart';

class JobsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new JobsPageState();
  }
}

class JobsPageState extends State<JobsPage> {
  var _jobs = [];
  var _scrollController = new ScrollController();
  var _rowTextStyle = new TextStyle(fontSize: 18.0);

  JobsPageState() {
    fetchJenkinsJobs();
  }

  void fetchJenkinsJobs() async {
    var apiHost = await Jenkins.fetchAPIHost();
    var headers = await Jenkins.fetchRequestHeader();
    var data = await Network.get(apiHost + Jenkins.API_SUFFIX, headers: headers);

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
      children: <Widget>[
        new Expanded(
            child: new Padding(
          padding: const EdgeInsets.all(15.0),
          child: new Text(_jobs[index].name, style: _rowTextStyle),
        ))
      ],
    );

    return new InkWell(
      child: jobNameRow,
      onTap: () {
        Navigator
            .of(context)
            .push(new MaterialPageRoute(builder: (BuildContext context) {
          return JobDetailsPage();
        }));
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
        child: new Text("There's no Jobs"),
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
