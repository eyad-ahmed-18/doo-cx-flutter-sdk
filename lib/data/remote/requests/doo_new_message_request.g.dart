// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doo_new_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DOONewMessageRequest _$DOONewMessageRequestFromJson(
        Map<String, dynamic> json) =>
    DOONewMessageRequest(
      content: json['content'] as String,
      echoId: json['echo_id'] as String,
    );

Map<String, dynamic> _$DOONewMessageRequestToJson(
        DOONewMessageRequest instance) =>
    <String, dynamic>{
      'content': instance.content,
      'echo_id': instance.echoId,
    };
