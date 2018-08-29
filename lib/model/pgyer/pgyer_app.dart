class PgyerApp {
  final String buildKey;
  final String buildFileSize;
  final String buildName;
  final String buildPassword;
  final String buildVersion;
  final String buildVersionNo;
  final String buildBuildVersion;
  final String buildUpdateDescription;
  final String buildIcon;
  final String buildQRCodeURL;
  final String buildCreated;
  final int todayDownloadCount;

  PgyerApp(
      {this.buildKey,
      this.buildFileSize,
      this.buildName,
      this.buildPassword,
      this.buildVersion,
      this.buildVersionNo,
      this.buildBuildVersion,
      this.buildUpdateDescription,
      this.buildIcon,
      this.buildQRCodeURL,
      this.buildCreated,
      this.todayDownloadCount});

  PgyerApp.fromJSON(Map<String, dynamic> json)
      : buildKey = json['buildKey'],
        buildFileSize = json['buildFileSize'],
        buildName = json['buildName'],
        buildPassword = json['buildPassword'],
        buildVersion = json['buildVersion'],
        buildVersionNo = json['buildVersionNo'],
        buildBuildVersion = json['buildBuildVersion'],
        buildUpdateDescription = json['buildUpdateDescription'],
        buildIcon = json['buildIcon'],
        buildQRCodeURL = json['buildQRCodeURL'],
        buildCreated = json['buildCreated'],
        todayDownloadCount = json['todayDownloadCount'];
}
