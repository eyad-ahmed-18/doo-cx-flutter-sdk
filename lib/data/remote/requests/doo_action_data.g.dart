// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doo_action_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DOOActionData _$DOOActionDataFromJson(Map<String, dynamic> json) =>
    DOOActionData(
      action: actionTypeFromJson(json['action'] as String?),
    );

Map<String, dynamic> _$DOOActionDataToJson(DOOActionData instance) =>
    <String, dynamic>{
      'action': actionTypeToJson(instance.action),
    };
