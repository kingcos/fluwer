class GitLabBranch {
  final String name;

  GitLabBranch({this.name});

  GitLabBranch.fromJSON(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJSON() => {'name': name};
}
