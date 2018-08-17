class JenkinsJob {
  final String name;
  final String url;

  JenkinsJob(this.name, this.url);

  JenkinsJob.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'];

  Map<String, dynamic> toJSON() => {
        'name': name,
        'url': url,
      };
}
