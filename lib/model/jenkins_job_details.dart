class JenkinsJobDetails {
  final String name;
  final String description;
  final List<JenkinsBuildParamDefinition> paramDefinitions;

  JenkinsJobDetails({this.name, this.description, this.paramDefinitions});

  JenkinsJobDetails.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        paramDefinitions = json['actions']['parameterDefinitions'];
}

class JenkinsBuildParamDefinition {
  final String name;
  final String description;
  final String type;
  final JenkinsBuildParamDefinitionDefaultValue defaultValue;

  JenkinsBuildParamDefinition(
      {this.name, this.description, this.type, this.defaultValue});

  JenkinsBuildParamDefinition.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        type = json['type'],
        defaultValue = json['actions']['parameterDefinitions'];
}

class JenkinsBuildParamDefinitionDefaultValue {
  final dynamic value;

  JenkinsBuildParamDefinitionDefaultValue({this.value});

  JenkinsBuildParamDefinitionDefaultValue.fromJSON(Map<String, dynamic> json)
      : value = json['value'];
}

class JenkinsJobBuild {
  final String number;

  JenkinsJobBuild({this.number});
}
