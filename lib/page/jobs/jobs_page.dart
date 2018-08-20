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
  List _jobs = new List<JenkinsJob>();
  ScrollController _scrollController = new ScrollController();
  int _currentPage = 0;

  JobsPageState() {
    _fetchJenkinsJobs(currentPage: _currentPage);
  }

  void _fetchJenkinsJobs({int currentPage, int perPage = 5}) async {
    var params = new Map<String, String>();
    params["tree"] = "jobs" + Uri.encodeQueryComponent("[name]{$currentPage,$perPage}");

    var url = await Jenkins.fetchAPIHost() + Jenkins.API_JSON_SUFFIX;
    var headers = await Jenkins.fetchRequestHeader();
    var data = await Network.get(url: url, params: params, headers: headers);

    if (data == null) {
      return;
    }

    setState(() {
      for (var jobJSON in json.decode(data)["jobs"]) {
        _jobs.add(JenkinsJob.fromJSON(jobJSON));
      }
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
              new Text(_jobs[index].name, style: new TextStyle(fontSize: 18.0)),
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
    if (_jobs == null || _jobs.length == 0) {
      return new Center(child: new CircularProgressIndicator());
    }

    return new ListView.builder(
        itemCount: _jobs.length * 2,
        itemBuilder: (BuildContext context, int index) {
          return _rowAt(index);
        },
        controller: _scrollController);
  }
}
