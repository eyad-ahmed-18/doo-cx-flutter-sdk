// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doo_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DOOAction _$DOOActionFromJson(Map<String, dynamic> json) => DOOAction(
      identifier: json['identifier'] as String,
      data: json['data'] == null
          ? null
          : DOOActionData.fromJson(json['data'] as Map<String, dynamic>),
      command: json['command'] as String,
    );

Map<String, dynamic> _$DOOActionToJson(DOOAction instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'command': instance.command,
      'data': instance.data?.toJson(),
    };
