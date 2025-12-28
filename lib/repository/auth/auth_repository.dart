import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/auth/user_response.dart';

class AuthRepository {
  final Dio dio;
  final Future<String> Function() getDeviceInfoFn;

  AuthRepository({required this.dio, required this.getDeviceInfoFn});

  // 新規登録
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    print('📡 authRepository.signUp() START');
    try {
      final response = await dio.post(
        '/users',
        data: {'username': username, 'email': email, 'password': password},
      );

      if (response.statusCode != 200) {
        throw HttpErrorException(
          message: response.data['error'] ?? '新規登録に失敗しました',
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ログイン
  Future<UserResponse> login({
  required String email,
  required String password,
}) async {
  try {
    final deviceInfo = await getDeviceInfoFn();
    final response = await dio.post(
      '/users/login',
      data: {'email': email, 'password': password},
      options: Options(headers: {'User-Agent': deviceInfo}),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromJson(response.data);
    }

    // 429: ロック中
    if (response.statusCode == 429) {
      final header = response.headers.map['retry-after']?.first;
      int seconds = int.tryParse(header ?? '') ?? 0;

      if (seconds <= 0) {
        final bodySec =
            (response.data is Map)
                ? int.tryParse('${response.data['retry_after_s'] ?? ''}') ?? 0
                : 0;
        seconds = bodySec > 0 ? bodySec : 60; // 最低60秒にフォールバック
      }

      final msg = (response.data is Map && response.data['error'] != null)
          ? response.data['error'].toString()
          : '一時的にロックされています';

      // 429 も HttpErrorException に統一
      throw HttpErrorException(
        message: msg,
        statusCode: 429,
        retryAfterSeconds: seconds,
      );
    }

    // その他エラー
    throw HttpErrorException(
      message: (response.data is Map && response.data["error"] != null)
          ? response.data["error"].toString()
          : '不明なエラーが発生しました',
      statusCode: response.statusCode ?? -1,
    );
  } catch (e) {
    rethrow;
  }
}


  //パスワードリセット
  Future<void> passwordReset(String email) async {
    try {
      final deviceInfo = await getDeviceInfoFn();
      final response = await dio.post(
        '/password_reset',
        data: {'email': email},
        options: Options(headers: {'User-Agent': deviceInfo}),
      );
      if (response.statusCode != 200) {
        throw HttpErrorException(
          message: response.data['error'] ?? 'メール送信に失敗しました',
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // アクセストークン更新
  Future<UserResponse> refreshAccessToken(String refreshToken) async {
    final deviceInfo = await getDeviceInfoFn();
    try {
      final response = await dio.post(
        "/tokens/renew_access",
        data: {"refresh_token": refreshToken},
        options: Options(headers: {'User-Agent': deviceInfo}),
      );

      if (response.statusCode == 200) {
        return UserResponse.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw HttpErrorException(
          message: "セッションが無効です。再ログインしてください",
          statusCode: response.statusCode!,
        );
      } else {
        throw HttpErrorException(
          message: response.data["error"]?.toString() ?? "不明なエラー",
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout({required String refreshToken}) async {
    try {
      final response = await dio.post(
        '/users/logout',
        data: {'refresh_token': refreshToken},
      );
      if (response.statusCode != 200) {
        throw HttpErrorException(
          message: response.data["error"]?.toString() ?? "不明なエラー",
          statusCode: response.statusCode!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
