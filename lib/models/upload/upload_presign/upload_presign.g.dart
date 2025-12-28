// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_presign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadPresign _$UploadPresignFromJson(Map<String, dynamic> json) =>
    _UploadPresign(
      presignedUrl: json['presigned_url'] as String,
      objectKey: json['object_key'] as String,
      documentId: (json['document_id'] as num).toInt(),
    );

Map<String, dynamic> _$UploadPresignToJson(_UploadPresign instance) =>
    <String, dynamic>{
      'presigned_url': instance.presignedUrl,
      'object_key': instance.objectKey,
      'document_id': instance.documentId,
    };
