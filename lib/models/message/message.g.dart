// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: (json['id'] as num).toInt(),
  sessionId: (json['session_id'] as num).toInt(),
  isUser: json['is_user'] as bool,
  message: json['message'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'is_user': instance.isUser,
  'message': instance.message,
  'created_at': instance.createdAt.toIso8601String(),
};
