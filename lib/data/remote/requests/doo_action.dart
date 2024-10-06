import 'package:json_annotation/json_annotation.dart';

import 'doo_action_data.dart';

part 'doo_action.g.dart';

@JsonSerializable(explicitToJson: true)
class DOOAction {
  @JsonKey()
  final String identifier;

  @JsonKey()
  final String command;

  @JsonKey()
  final DOOActionData? data;

  DOOAction({required this.identifier, this.data, required this.command});

  factory DOOAction.fromJson(Map<String, dynamic> json) =>
      _$DOOActionFromJson(json);

  Map<String, dynamic> toJson() => _$DOOActionToJson(this);
}
