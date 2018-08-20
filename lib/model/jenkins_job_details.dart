class JenkinsJobDetails {
  final String name;
  final String description;

  JenkinsJobDetails({this.name, this.description});

  JenkinsJobDetails.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'];
}

class JenkinsJobBuild {
  final String number;

  JenkinsJobBuild({this.number});
}
