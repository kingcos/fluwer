class JiraFilter {
  final String searchUrl;

  JiraFilter({this.searchUrl});

  JiraFilter.fromJSON(Map<String, dynamic> json)
      : searchUrl = json['searchUrl'];
}
