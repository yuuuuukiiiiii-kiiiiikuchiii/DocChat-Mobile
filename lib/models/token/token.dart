import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';

@freezed
abstract class TokenModel with _$TokenModel {
  factory TokenModel({
    String? accessToken,
    DateTime? accessTokenExpiresAt,
    String? refreshToken,
    DateTime? refreshTokenExpiresAt,
    @Default(false) bool firstLaunchCompleted,
  }) = _TokenModel;
}
