import 'package:flutter/material.dart';

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

  JobDetailsPageState({Key key, this.jobName});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("$jobName"),
      ),
      
    );
  }
}
