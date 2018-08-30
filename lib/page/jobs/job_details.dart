import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwer/model/jenkins/jenkins_job_details.dart';
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
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _jobName;
  JenkinsJobDetails _jobDetails;
  List<String> _paramValues;

  JobDetailsPageState({String jobName}) {
    _jobName = jobName;
  }

  @override
  void initState({String jobName}) {
    super.initState();

    _fetchJobDetails();
  }

  void _fetchJobDetails() async {
    var apiHost = await Jenkins.fetchAPIHost();
    var headers = await Jenkins.fetchRequestHeader();
    var data = await Network.get(
        url: apiHost + Jenkins.API_JOB + _jobName + Jenkins.API_JSON_SUFFIX,
        headers: headers);

    if (data == null) {
      return;
    }

    setState(() {
      var jobDetailsJSON = json.decode(data);

      _jobDetails = JenkinsJobDetails.fromJSON(jobDetailsJSON);

      _paramValues =
          new List<String>(_jobDetails.paramAction.paramDefinitions.length);
    });
  }

  void _fetchJobBuilds() async {

  }

  Future<Null> _pullToRefresh() async {
    setState(() {
      _fetchJobDetails();
      _fetchJobBuilds();
    });
  }

  List<Widget> _buildWidgets() {
    List widgets = new List<Widget>();

    widgets.add(new Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Text(_jobDetails.description,
            style: new TextStyle(fontSize: 16.0))));

    var jobParams = _jobDetails.paramAction.paramDefinitions;

    for (int index = 0; index < jobParams.length; index += 1) {
      if (jobParams[index].className == Jenkins.BUILD_PARAM_TYPE_STRING) {
        // String Param

        widgets.add(new Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: new TextFormField(
            initialValue: jobParams[index].defaultValue.value,
            decoration: new InputDecoration(
              labelText: jobParams[index].name,
              helperText: jobParams[index].description,
              helperStyle: const TextStyle(fontSize: 10.0),
            ),
            onSaved: (value) {
              setState(() {
                _paramValues[index] = value;
              });
            },
          ),
        ));
      } else if (jobParams[index].className ==
          Jenkins.BUILD_PARAM_TYPE_CHOICE) {
        // Choices Param

        widgets.add(new Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
            child: new Container(
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                  new Container(
                    width: 200.0,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(jobParams[index].name),
                        new Text(jobParams[index].description,
                            style: const TextStyle(fontSize: 10.0)),
                      ],
                    ),
                  ),
                  new Container(
                    child: new ButtonTheme(
                      alignedDropdown: true,
                      child: new DropdownButton<String>(
                          value: _paramValues[index],
                          hint: new Text(jobParams[index].defaultValue.value),
                          items: jobParams[index].choices.map((choice) {
                            return new DropdownMenuItem(
                                value: choice, child: new Text(choice));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _paramValues[index] = value;
                            });
                          }),
                    ),
                  )
                ]))));
      }
    }

    return widgets;
  }

  void _triggerBuild() async {
    var url = await Jenkins.fetchAPIHost() +
        Jenkins.API_JOB +
        _jobDetails.name +
        Jenkins.API_BUILD;
    var headers = await Jenkins.fetchRequestHeader();
    var body = Jenkins.buildRequestBody(
        keys: _jobDetails.paramAction.paramDefinitions
            .map((e) => e.name)
            .toList(),
        values: _paramValues);

    await Network.post(url: url, headers: headers, body: body);
  }

  @override
  Widget build(BuildContext context) {
    if (_jobDetails == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(_jobName),
        ),
        body: new Center(child: new CircularProgressIndicator()),
      );
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(_jobName),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.update),
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: const Text(
                              "Are you sure to start this Jenkins job?"),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _formKey.currentState.save();
                                  _triggerBuild();
                                  _pullToRefresh();
                                },
                                child: const Text("YES")),
                            new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("NO"))
                          ],
                        );
                      });
                }),
          ],
        ),
        body: new RefreshIndicator(
            child: new DecoratedBox(
                decoration: const BoxDecoration(color: const Color(0xFFEFEFF4)),
                child: new Form(
                    key: _formKey,
                    child: new ListView(
                      children: _buildWidgets(),
                    ))),
            onRefresh: _pullToRefresh));
  }
}
