// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserResponse _$UserResponseFromJson(Map<String, dynamic> json) =>
    _UserResponse(
      accessToken: json['access_token'] as String,
      accessTokenExpiresAt: json['access_token_expires_at'] as String,
      refreshToken: json['refresh_token'] as String,
      refreshTokenExpiresAt: json['refresh_token_expires_at'] as String,
      user:
          json['user'] == null
              ? null
              : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseToJson(_UserResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'access_token_expires_at': instance.accessTokenExpiresAt,
      'refresh_token': instance.refreshToken,
      'refresh_token_expires_at': instance.refreshTokenExpiresAt,
      'user': instance.user?.toJson(),
    };

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  lastLoginAt: json['last_login_at'] as String,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'last_login_at': instance.lastLoginAt,
    };
