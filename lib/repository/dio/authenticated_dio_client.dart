import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rag_faq_document/models/auth/user_response.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';

class AuthenticatedDioClient {
  final Dio dio;
  final LocalStorage storage;
  final String baseUrl;
  final VoidCallback onUnauthorized;
  final Future<String> Function() deviceInfoGetter;

  AuthenticatedDioClient({
    required this.storage,
    required this.baseUrl,
    required this.onUnauthorized,
    required this.deviceInfoGetter,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 10),
           contentType: 'application/json',
         ),
       ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getAccessToken();
          options.headers["Authorization"] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            print("ステータスコード:401");
            final success = await _refreshToken();
            if (success == true) {
              final newToken = await storage.getAccessToken();
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';
              final cloneReq = await dio.fetch(error.requestOptions);
              return handler.resolve(cloneReq);
            } else {
              await storage.clearTokens();
              onUnauthorized(); // ✅ ここで画面遷移処理
              return;
            }
          } else {
            return handler.reject(error);
          }
        },
      ),
    );
  }
  Future<bool> _refreshToken() async {
    print("refresh start");
    final refreshToken = await storage.getRefreshToken();
    final deviceInfo = deviceInfoGetter;

    // 別のDioインスタンスを使う！Interceptorが付いてない
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );
    try {
      final response = await refreshDio.post(
        "/tokens/renew_access",
        data: {"refresh_token": refreshToken},
        options: Options(
          headers: {'Authorization': '', 'User-Agent': deviceInfo},
        ),
      );
      final responseData = response.data;
      print(responseData);
      final data = UserResponse.fromJson(responseData);
      print(data);
      await storage.saveTokens(
        accessToken: data.accessToken,
        accessTokenExpiresAt: data.accessTokenExpiresAt,
        refreshToken: data.refreshToken,
        refreshTokenExpiresAt: data.refreshTokenExpiresAt,
      );
      print("リフレッシュトークン取得成功");
      return true;
    } catch (e) {
      print("リフレッシュ失敗: $e");
      return false;
    }
  }
}
