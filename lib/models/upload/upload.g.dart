// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) =>
    _UploadResponse(
      documentId: (json['document_id'] as num).toInt(),
      status: json['status'] as String,
      filename: json['filename'] as String,
    );

Map<String, dynamic> _$UploadResponseToJson(_UploadResponse instance) =>
    <String, dynamic>{
      'document_id': instance.documentId,
      'status': instance.status,
      'filename': instance.filename,
    };
