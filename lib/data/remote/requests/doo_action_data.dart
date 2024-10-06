import 'package:json_annotation/json_annotation.dart';

part 'doo_action_data.g.dart';

@JsonSerializable(explicitToJson: true)
class DOOActionData {
  @JsonKey(toJson: actionTypeToJson, fromJson: actionTypeFromJson)
  final DOOActionType action;

  DOOActionData({required this.action});

  factory DOOActionData.fromJson(Map<String, dynamic> json) =>
      _$DOOActionDataFromJson(json);

  Map<String, dynamic> toJson() => _$DOOActionDataToJson(this);
}

enum DOOActionType { subscribe, update_presence }

String actionTypeToJson(DOOActionType actionType) {
  switch (actionType) {
    case DOOActionType.update_presence:
      return "update_presence";
    case DOOActionType.subscribe:
      return "subscribe";
  }
}

DOOActionType actionTypeFromJson(String? value) {
  switch (value) {
    case "update_presence":
      return DOOActionType.update_presence;
    case "subscribe":
      return DOOActionType.subscribe;
    default:
      return DOOActionType.update_presence;
  }
}
