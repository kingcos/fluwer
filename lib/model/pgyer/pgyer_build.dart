class PgyerBuild {
  final String buildName;
  final String buildVersion;
  final String buildVersionNo;
  final String buildUpdateDescription;
  final String buildIcon;
  final String buildCreated;

  PgyerBuild(
      {this.buildName,
      this.buildVersion,
      this.buildVersionNo,
      this.buildUpdateDescription,
      this.buildIcon,
      this.buildCreated});

  PgyerBuild.fromJSON(Map<String, dynamic> json)
      : buildName = json['buildName'],
        buildVersion = json['buildVersion'],
        buildVersionNo = json['buildVersionNo'],
        buildUpdateDescription = json['buildUpdateDescription'],
        buildIcon = json['buildIcon'],
        buildCreated = json['buildCreated'];
}
