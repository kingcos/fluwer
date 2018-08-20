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
  int _currentPage;

  List _jobs;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _currentPage = 0;
    _scrollController = new ScrollController();
    _fetchJenkinsJobs(currentPage: _currentPage);
  }

  void _fetchJenkinsJobs({int currentPage, int perPage = 5}) async {
    var params = new Map<String, String>();
    params["tree"] =
        "jobs" + Uri.encodeQueryComponent("[name]{$currentPage,$perPage}");

    var url = await Jenkins.fetchAPIHost() + Jenkins.API_JSON_SUFFIX;
    var headers = await Jenkins.fetchRequestHeader();
    var data = await Network.get(url: url, params: params, headers: headers);

    if (data == null) {
      return;
    }

    _jobs = new List<JenkinsJob>();

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
    if (_jobs == null) {
      return new Center(child: new CircularProgressIndicator());
    }

    if (_jobs.length == 0) {
      return new Center(
        child: new Text(Constants.NO_DATA_PLACEHOLDER, style: new TextStyle(fontSize: 22.0), textAlign: TextAlign.center,),
      );
    }

    return new ListView.builder(
        itemCount: _jobs.length * 2,
        itemBuilder: (BuildContext context, int index) {
          return _rowAt(index);
        },
        controller: _scrollController);
  }
}
