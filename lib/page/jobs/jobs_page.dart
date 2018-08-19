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

  JobsPageState() {
    fetchJenkinsJobs();
  }

  void fetchJenkinsJobs() async {
    var apiHost = await Jenkins.fetchAPIHost();
    var headers = await Jenkins.fetchRequestHeader();
    var data = await Network.get(
        url: apiHost + Jenkins.API_JSON_SUFFIX, headers: headers);

    if (data == null) {
      return;
    }

    setState(() {
      for (var jobJSON in json.decode(data)["jobs"]) {
        _jobs.add(JenkinsJob.fromJson(jobJSON));
      }
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
