class JenkinsJob {
  final String name;

  JenkinsJob({this.name});

  JenkinsJob.fromJSON(Map<String, dynamic> json) : name = json['name'];
}
