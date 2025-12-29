import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/core/app_state.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/repository/auth/auth_repository.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';
import 'package:rag_faq_document/utils/utils.dart';

class AuthService {
  final LocalStorage storage;
  final AuthRepository repo;
  final Ref ref;
  AuthService({required this.storage, required this.repo, required this.ref});

  // 新規登録
  Future<void> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await repo.signup(username: username, email: email, password: password);
    } on HttpErrorException catch (e) {
      final userMessage = mapHttpErrorToUserMessage(e.message, e.statusCode);
      throw CustomError.server(
        statusCode: e.statusCode,
        message: e.message,
        userMessage: userMessage,
      );
    } catch (e) {
      print("💥 Caught in AuthService: ${e.runtimeType}");
      throw handleException(e);
    }
  }

  //ログアウト
  Future<void> logout() async {
    try {
      final refreshToken = await storage.loadRefresh();
      if (refreshToken != null) {
        await repo.logout(refreshToken: refreshToken);
        await storage.clear();
      }
    } on HttpErrorException catch (e) {
      final userMessage = mapHttpErrorToUserMessage(e.message, e.statusCode);
      throw CustomError.server(
        statusCode: e.statusCode,
        message: e.message,
        userMessage: userMessage,
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  // ログイン
  Future<void> login({required String email, required String password}) async {
    try {
      final data = await repo.login(email: email, password: password);
      await storage.setAccess(data.accessToken);
      await storage.saveRefresh(data.refreshToken);
      
    } on HttpErrorException catch (e) {
      final userMessage = mapHttpErrorToUserMessage(
      e.message,
      e.statusCode,
      retryAfterSeconds: e.retryAfterSeconds,
    );
    throw CustomError.server(
      statusCode: e.statusCode,
      message: e.message,
      userMessage: userMessage,
    );
    } catch (e) {
      print("💥 Caught in AuthService: ${e.runtimeType}");
      throw handleException(e);
    }
  }

  //パスワードリセット
  Future<void> passwordReset(String email) async {
    try {
      await repo.passwordReset(email);
    } on HttpErrorException catch (e) {
      final userMessage = mapHttpErrorToUserMessage(e.message, e.statusCode);
      throw CustomError.server(
        statusCode: e.statusCode,
        message: e.message,
        userMessage: userMessage,
      );
    } catch (e) {
      print("💥 Caught in AuthService: ${e.runtimeType}");
      throw handleException(e);
    }
  }

  //アクセストークン更新
  Future<void> refreshAccessToken(String refreshToken) async {
    try {
      print("refresh start");
      final data = await repo.refreshAccessToken(refreshToken);
      print(data.accessToken);
      await storage.setAccess(data.accessToken);
      await storage.saveRefresh(data.refreshToken);
      final newAccessToken = storage.access;
      final newRefreshToken = await storage.loadRefresh();

      ref.read(authStatusProvider.notifier).state = AuthStatus.authenticated;
      print("新しいアクセストークン:$newAccessToken、新しいリフレッシュトークン:$newRefreshToken");
    } on HttpErrorException catch (e) {
      if (e.statusCode == 401) {
        print("🔴 サーバーがリフレッシュトークンを拒否（401）");
        await storage.clear();
        final userMessage = mapHttpErrorToUserMessage(e.message, e.statusCode);
        throw CustomError.server(
          statusCode: e.statusCode,
          message: e.message,
          userMessage: userMessage,
        );
      } else {
        final userMessage = mapHttpErrorToUserMessage(e.message, e.statusCode);
        throw CustomError.server(
          statusCode: e.statusCode,
          message: e.message,
          userMessage: userMessage,
        );
      }
    } catch (e) {
      throw handleException(e);
    }
  }
}
