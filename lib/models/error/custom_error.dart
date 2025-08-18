import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_error.freezed.dart';

@freezed
abstract class CustomError with _$CustomError {
  const factory CustomError.server({
    required int statusCode,
    required String message,
    required String userMessage,
  }) = ServerError;

  const factory CustomError.timeout({
    required String message,
    @Default('リクエストがタイムアウトしました。時間を置いて再試行してください。') String userMessage,
  }) = TimeoutError;

  const factory CustomError.network({
    required String message,
    @Default('ネットワークに接続できません。接続を確認してください。') String userMessage,
  }) = NetworkError;

  const factory CustomError.unknown({
    required String message,
    @Default('不明なエラーが発生しました。') String userMessage,
  }) = UnknownError;
}


// @freezed
// class LoginResponse with _$LoginResponse {
//   const factory LoginResponse({
//     @JsonKey(name: 'access_token') required String accessToken,
//     @JsonKey(name: 'access_token_expires_at') required DateTime accessTokenExpiresAt,
//     @JsonKey(name: 'refresh_token') required String refreshToken,
//     @JsonKey(name: 'refresh_token_expires_at') required DateTime refreshTokenExpiresAt,
//     required User user,
//   }) = _LoginResponse;

//   factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
// }

// @freezed
// class User with _$User {
//   const factory User({
//     required int id,
//     required String username,
//     required String email,
//     @JsonKey(name: 'created_at') required DateTime createdAt,
//     @JsonKey(name: 'updated_at') required DateTime updatedAt,
//     @JsonKey(name: 'last_login_at') required DateTime lastLoginAt,
//   }) = _User;

//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
// }

