class JenkinsJob {
  final String name;

  JenkinsJob({this.name});

  JenkinsJob.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJSON() => {'name': name};
}
