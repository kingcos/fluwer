class JiraIssue {
  final String key;
  final String displayName;
  final String statusName;
  final String summary;

  JiraIssue({this.key, this.displayName, this.statusName, this.summary});

  JiraIssue.fromJSON(Map<String, dynamic> json)
      : key = json['key'],
        displayName = json['fields']['assignee']['displayName'],
        statusName = json['fields']['status']['name'],
        summary = json['fields']['summary'];
}
