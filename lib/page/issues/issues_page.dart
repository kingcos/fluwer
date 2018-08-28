import 'package:flutter/material.dart';

class IssuesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IssuesPageState();
  }
}
//e "startAt" and "maxResults"
class IssuesPageState extends State<IssuesPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("Issues"),
    );
  }
}
