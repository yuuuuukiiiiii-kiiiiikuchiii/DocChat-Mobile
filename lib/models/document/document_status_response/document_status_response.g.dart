// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentStatusResponse _$DocumentStatusResponseFromJson(
  Map<String, dynamic> json,
) => _DocumentStatusResponse(
  documentId: (json['document_id'] as num).toInt(),
  chatId: (json['chat_id'] as num?)?.toInt(),
  filename: json['filename'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$DocumentStatusResponseToJson(
  _DocumentStatusResponse instance,
) => <String, dynamic>{
  'document_id': instance.documentId,
  'chat_id': instance.chatId,
  'filename': instance.filename,
  'status': instance.status,
};
