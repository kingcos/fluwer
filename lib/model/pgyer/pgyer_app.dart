class PgyerApp {
  final String buildKey;
  final String buildName;
  final String buildPassword;
  final String buildVersion;
  final String buildVersionNo;
  final String buildUpdateDescription;
  final String buildIcon;
  final String buildQRCodeURL;
  final String buildCreated;

  PgyerApp(
      {this.buildKey,
      this.buildName,
      this.buildPassword,
      this.buildVersion,
      this.buildVersionNo,
      this.buildUpdateDescription,
      this.buildIcon,
      this.buildQRCodeURL,
      this.buildCreated});

  PgyerApp.fromJSON(Map<String, dynamic> json)
      : buildKey = json['buildKey'],
        buildName = json['buildName'],
        buildPassword = json['buildPassword'],
        buildVersion = json['buildVersion'],
        buildVersionNo = json['buildVersionNo'],
        buildUpdateDescription = json['buildUpdateDescription'],
        buildIcon = json['buildIcon'],
        buildQRCodeURL = json['buildQRCodeURL'],
        buildCreated = json['buildCreated'];
}
