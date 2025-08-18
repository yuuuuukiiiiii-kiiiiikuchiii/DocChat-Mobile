import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/token/token.dart';
import 'package:rag_faq_document/repository/auth/auth_repository.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';
import 'package:rag_faq_document/utils/utils.dart';

class AuthService {
  final LocalStorage storage;
  final AuthRepository repo;
  AuthService({required this.storage, required this.repo});

  // 新規登録
  Future<void> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await repo.signUp(username: username, email: email, password: password);
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
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null) {
        await repo.logout(refreshToken: refreshToken);
        await storage.clearTokens();
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
      await storage.saveTokens(
        accessToken: data.accessToken,
        accessTokenExpiresAt: data.accessTokenExpiresAt,
        refreshToken: data.refreshToken,
        refreshTokenExpiresAt: data.refreshTokenExpiresAt,
      );
      await storage.saveUser(
        id: data.user!.id,
        username: data.user!.username,
        email: data.user!.email,
        createdAt: data.user!.createdAt,
        updatedAt: data.user!.updatedAt,
        lastLoginAt: data.user!.lastLoginAt,
      );
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

  // アクセストークン更新
  Future<TokenModel> refreshAccessToken(String refreshToken) async {
    try {
      print("refresh start");
      final data = await repo.refreshAccessToken(refreshToken);
      print(data.accessToken);
      await storage.saveTokens(
        accessToken: data.accessToken,
        accessTokenExpiresAt: data.accessTokenExpiresAt,
        refreshToken: data.refreshToken,
        refreshTokenExpiresAt: data.refreshTokenExpiresAt,
      );
      final token = await storage.getToken();
      print(
        "新しいアクセストークン:${token.accessToken}、新しいリフレッシュトークン:${token.refreshToken}",
      );
      return token;
    } on HttpErrorException catch (e) {
      if (e.statusCode == 401) {
        print("🔴 サーバーがリフレッシュトークンを拒否（401）");
        await storage.clearTokens();
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
