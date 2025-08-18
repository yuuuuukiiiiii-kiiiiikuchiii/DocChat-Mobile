import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response.freezed.dart';
part 'user_response.g.dart';

@freezed
abstract class UserResponse with _$UserResponse {
  @JsonSerializable(explicitToJson: true)
  factory UserResponse({
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "access_token_expires_at")
    required String accessTokenExpiresAt,
    @JsonKey(name: "refresh_token") required String refreshToken,
    @JsonKey(name: "refresh_token_expires_at")
    required String refreshTokenExpiresAt,
    UserModel? user,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

@freezed
abstract class UserModel with _$UserModel {
  factory UserModel({
    required int id,
    required String username,
    required String email,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "updated_at") required String updatedAt,
    @JsonKey(name: "last_login_at") required String lastLoginAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
