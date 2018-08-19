import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwer/model/jenkins_job_details.dart';
import 'package:fluwer/utility/jenkins.dart';
import 'package:fluwer/utility/network.dart';

class JobDetailsPage extends StatefulWidget {
  final String name;

  JobDetailsPage({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new JobDetailsPageState(jobName: name);
  }
}

class JobDetailsPageState extends State<JobDetailsPage> {
  String jobName;
  JenkinsJobDetails _jobDetails;

  JobDetailsPageState({Key key, this.jobName}) {
    fetchJobDetails();
  }

  void fetchJobDetails({String branch, String packType, String email}) async {
    var apiHost = await Jenkins.fetchAPIHost();
    var headers = await Jenkins.fetchRequestHeader();
    var data = await Network.get(
        url: apiHost +
            Jenkins.API_JOB_DETAILS +
            jobName +
            Jenkins.API_JSON_SUFFIX,
        headers: headers);

    if (data == null) {
      return;
    }

    setState(() {
      var jobDetailsJSON = json.decode(data);

      _jobDetails = JenkinsJobDetails.fromJson(jobDetailsJSON);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_jobDetails == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(jobName),
        ),
        body: new Center(child: new CircularProgressIndicator()),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(jobName),
      ),
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Text(_jobDetails.description,
                style: new TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    );
  }
}
