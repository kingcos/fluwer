import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwer/model/gitlab_branch.dart';
import 'package:fluwer/model/jenkins_job_details.dart';
import 'package:fluwer/utility/gitlab.dart';
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
  int _selectedItemIndex = 0;
  List _branches = new List<String>();

  JobDetailsPageState({Key key, this.jobName}) {
    _fetchGitLabRepoBranches();
    _fetchJobDetails();
  }

  void _fetchGitLabRepoBranches() async {
    var repoID = await GitLab.fetchRepoID();
    var url = await GitLab.fetchAPIHost() +
        GitLab.API_PREFIX +
        GitLab.API_PROJECTS +
        repoID +
        GitLab.API_REPO_BRANCHES +
        "?page=1&per_page=100";
    var headers = await GitLab.fetchRequestHeader();

    var data = await Network.get(url: url, headers: headers);

    if (data == null) {
      return;
    }

    setState(() {
      for (var branchJSON in json.decode(data)) {
        print(GitLabBranch.fromJSON(branchJSON).name);
        _branches.add(GitLabBranch.fromJSON(branchJSON).name);
      }
    });
  }

  void _fetchJobDetails({String branch, String packType, String email}) async {
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

      _jobDetails = JenkinsJobDetails.fromJSON(jobDetailsJSON);
    });
  }

  Widget _buildPicker({String title, List<String> data}) {
    if (data.length == 0) {
      return new Center(child: const CupertinoActivityIndicator());
    }

    return new Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        border: const Border(
          top: const BorderSide(color: const Color(0xFFBCBBC1), width: 0.0),
          bottom: const BorderSide(color: const Color(0xFFBCBBC1), width: 0.0),
        ),
      ),
      height: 44.0,
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new DefaultTextStyle(
            style: const TextStyle(
              letterSpacing: -0.24,
              fontSize: 17.0,
              color: CupertinoColors.black,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(title),
                new Text(
                  data[_selectedItemIndex],
                  style: const TextStyle(color: CupertinoColors.inactiveGray),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_jobDetails == null || _branches.length == 9) {
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
        body: new DecoratedBox(
          decoration: const BoxDecoration(color: const Color(0xFFEFEFF4)),
          child: new ListView(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: new Text(_jobDetails.description,
                      style: new TextStyle(fontSize: 16.0))),
              new GestureDetector(
                onTap: () async {},
                child: _buildPicker(title: "test1", data: _branches),
              ),
              new GestureDetector(
                onTap: () async {},
                child: _buildPicker(title: "test2", data: _branches),
              ),
              new GestureDetector(
                onTap: () async {},
                child: _buildPicker(title: "test3", data: _branches),
              )
            ],
          ),
        ));
  }
}
