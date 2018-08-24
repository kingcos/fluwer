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
  String className;
  String name;
  String description;
  String type;
  JenkinsBuildParamDefinitionDefaultValue defaultValue;
  List<String> choices;

  JenkinsBuildParamDefinition(
      {this.className,
      this.name,
      this.description,
      this.type,
      this.defaultValue,
      this.choices});

  JenkinsBuildParamDefinition.fromJSON(Map<String, dynamic> json) {
    className = json['_class'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    defaultValue = JenkinsBuildParamDefinitionDefaultValue
        .fromJSON(new Map<String, dynamic>.from(json['defaultParameterValue']));
    if (json['choices'] != null) {
      choices = new List<String>.from(json['choices']);
    }
  }
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
