import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';

class AuthenticatedDioClient {
  final Dio dio;
  final LocalStorage storage;
  final String baseUrl;
  final VoidCallback onUnauthorized;
  final Future<String> Function() deviceInfoGetter;

  final Dio Function(BaseOptions) refreshDioFactory;

  // --- 多重リフレッシュ抑止 ---
  Completer<bool>? _refreshingCompleter;

  AuthenticatedDioClient({
    required this.storage,
    required this.baseUrl,
    required this.onUnauthorized,
    required this.deviceInfoGetter,
    Dio Function(BaseOptions)? refreshDioFactory,
  }) : refreshDioFactory = refreshDioFactory ?? ((o) => Dio(o)),
       dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 10),

           // contentType は固定しない（各リクエストで指定する）
         ),
       ) {
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final access = storage.access;
          print(
            '➡️ ${options.method} ${options.path} authHeader=${access != null}',
          );
          if (access != null && access.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $access';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // 401 以外は素直に上位へ
          if (error.response?.statusCode != 401) {
            return handler.reject(error);
          }

          final original = error.requestOptions;

          // すでに誰かがリフレッシュ中 → それを待つ（single-flight）
          if (_refreshingCompleter != null) {
            final ok = await _refreshingCompleter!.future;
            return ok
                ? _retryWithPossiblyNewBody(original, handler, error)
                : _failUnauthorized(handler, original, error);
          }

          // 自分が代表してリフレッシュ
          _refreshingCompleter = Completer<bool>();
          final ok = await _refreshToken().catchError((_) => false);
          _refreshingCompleter!.complete(ok);
          _refreshingCompleter = null;

          return ok
              ? _retryWithPossiblyNewBody(original, handler, error)
              : _failUnauthorized(handler, original, error);
        },
      ),
    );
  }

  /// 401後の再送。multipart は FormData を再生成、JSONはそのまま。
  Future<void> _retryWithPossiblyNewBody(
    RequestOptions ro,
    ErrorInterceptorHandler handler,
    DioException error,
  ) async {
    final newToken = storage.access;
    if (newToken == null || newToken.isEmpty) {
      return _failUnauthorized(handler, ro, error);
    }

    // 新しいアクセストークンを付け替え
    ro.headers['Authorization'] = 'Bearer $newToken';

    // content-type 判定（requestOptions.contentType または ヘッダ）
    final contentType =
        ro.contentType ?? ro.headers['content-type']?.toString() ?? '';

    if (contentType.contains('multipart/form-data')) {
      // 送信済みの FormData は再利用不可。extra に入れたクロージャで再生成する
      final recreate = ro.extra['recreateFormData'];
      if (recreate is Future<FormData> Function()) {
        ro.data = await recreate();
      } else {
        // 再生成情報が無ければ安全に失敗させる
        return handler.reject(error);
      }
    } else {
      // application/json 等は ro.data をそのまま再送でOK
    }

    // 再送
    final retried = await dio.fetch(ro);
    return handler.resolve(retried);
  }

  /// セッション失効の共通終端処理
  bool _isDialogShown = false;

  Future<void> _failUnauthorized(
    ErrorInterceptorHandler handler,
    RequestOptions ro,
    DioException error,
  ) async {
    await storage.clear();
    if (!_isDialogShown) {
      _isDialogShown = true;
      onUnauthorized();
      Future.delayed(const Duration(seconds: 3), () => _isDialogShown = false);
    }
    handler.reject(error); // ← 追加
  }

  Future<bool> _refreshToken() async {
    print("refresh start");
    final refreshToken = await storage.loadRefresh();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    final deviceInfo = await deviceInfoGetter();

    // 別のDioインスタンスを使う！Interceptorが付いてない
    final refreshDio = refreshDioFactory(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    try {
      final response = await refreshDio.post(
        "/auth/refresh",
        data: {"refresh_token": refreshToken},
        options: Options(
          contentType: 'application/json',
          headers: {'Authorization': '', 'User-Agent': deviceInfo},
        ),
      );

      // ★ ここを置き換え（UserResponse.fromJsonを使わず直読み）
      final map = response.data as Map<String, dynamic>;
      final newAccess = map['access_token'] as String?;
      final newRefresh = map['refresh_token'] as String?;
      if (newAccess == null ||
          newAccess.isEmpty ||
          newRefresh == null ||
          newRefresh.isEmpty) {
        print("リフレッシュ失敗: token fields missing");
        return false;
      }
      
      await storage.setAccess(newAccess);
      await storage.saveRefresh(newRefresh);
      print("リフレッシュトークン取得成功");
      return true;
    } catch (e) {
      print("リフレッシュ失敗: $e");
      return false;
    }
  }
}
