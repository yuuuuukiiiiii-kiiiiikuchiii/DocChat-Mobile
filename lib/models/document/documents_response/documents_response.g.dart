// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentsResponse _$DocumentsResponseFromJson(Map<String, dynamic> json) =>
    _DocumentsResponse(
      id: (json['id'] as num).toInt(),
      filename: json['filename'] as String,
      filetype: json['filetype'] as String,
      fileurl: json['fileurl'] as String,
    );

Map<String, dynamic> _$DocumentsResponseToJson(_DocumentsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'filetype': instance.filetype,
      'fileurl': instance.fileurl,
    };
