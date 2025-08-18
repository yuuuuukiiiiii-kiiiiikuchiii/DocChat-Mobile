// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  userName: json['username'] as String? ?? 'ユーザー名',
  email: json['email'] as String? ?? 'user@example.com',
  createdAt: json['created_at'] as String? ?? "2024年1月1日",
  totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
  totalDocuments: (json['total_documents'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'username': instance.userName,
  'email': instance.email,
  'created_at': instance.createdAt,
  'total_questions': instance.totalQuestions,
  'total_documents': instance.totalDocuments,
};
