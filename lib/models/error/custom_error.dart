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


