class JenkinsJobDetails {
  final String name;
  final String description;
  final JenkinsBuildParamAction paramAction;

  JenkinsJobDetails({this.name, this.description, this.paramAction});

  JenkinsJobDetails.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        paramAction = JenkinsBuildParamAction
            .fromJSON(new Map<String, dynamic>.from(json['actions'][0]));
}

class JenkinsBuildParamAction {
  final List<JenkinsBuildParamDefinition> paramDefinitions;

  JenkinsBuildParamAction({this.paramDefinitions});

  JenkinsBuildParamAction.fromJSON(Map<String, dynamic> json)
      : paramDefinitions = (json['parameterDefinitions'] as List)
            .map((i) => JenkinsBuildParamDefinition.fromJSON(i))
            .toList();
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
        defaultValue = JenkinsBuildParamDefinitionDefaultValue.fromJSON(
            new Map<String, dynamic>.from(json['defaultParameterValue']));
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
