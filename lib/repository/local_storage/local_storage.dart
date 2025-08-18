import 'package:rag_faq_document/models/token/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<void> saveTokens({
    required String accessToken,
    required String accessTokenExpiresAt,
    required String refreshToken,
    required String refreshTokenExpiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('access_token_expires_at', accessTokenExpiresAt);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('refresh_token_expires_at', refreshTokenExpiresAt);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('access_token_expires_at');
    await prefs.remove('refresh_token');
    await prefs.remove('refresh_token_expires_at');
  }

  Future<TokenModel> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      final accessTokenExpiresAtStr = prefs.getString(
        'access_token_expires_at',
      );
      final refreshToken = prefs.getString('refresh_token');
      final refreshTokenExpiresAtStr = prefs.getString(
        'refresh_token_expires_at',
      );
      final firstLaunchCompleted =
          prefs.getBool('first_launch_completed') ?? false;

      final accessTokenExpiresAt =
          accessTokenExpiresAtStr != null
              ? DateTime.tryParse(accessTokenExpiresAtStr)
              : null;

      final refreshTokenExpiresAt =
          refreshTokenExpiresAtStr != null
              ? DateTime.tryParse(refreshTokenExpiresAtStr)
              : null;

      return TokenModel(
        accessToken: accessToken,
        accessTokenExpiresAt: accessTokenExpiresAt,
        refreshToken: refreshToken,
        refreshTokenExpiresAt: refreshTokenExpiresAt,
        firstLaunchCompleted: firstLaunchCompleted,
      );
    } catch (e) {
      print('❌ Failed to load token: $e');
      return TokenModel(); // 空のデフォルト
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch_completed', true);
  }

  Future<void> saveUser({
    required int id,
    required String username,
    required String email,
    required String createdAt,
    required String updatedAt,
    required String lastLoginAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('user_id', id);
    await prefs.setString('user_name', username);
    await prefs.setString('email', email);
    await prefs.setString('created_at', createdAt);
    await prefs.setString('updated_at', updatedAt);
    await prefs.setString('lastLogin_at', lastLoginAt);
  }

  //   Future<UserModel> getUser() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final userId = prefs.getInt('user_id');
  //     final username = prefs.getString('user_name');
  //     final email = prefs.getString('email');
  //     final createdAtStr = prefs.getString('access_token_expires_at');
  //     final updatedAtStr = prefs.getString('updated_at');

  //     final lastLoginAtStr = prefs.getString('lastLogin_at');

  //     final createdAt =
  //         createdAtStr != null ? DateTime.tryParse(createdAtStr) : null;

  //     final updatedAt =
  //         updatedAtStr != null ? DateTime.tryParse(updatedAtStr) : null;

  //     final lastLoginAt =
  //         lastLoginAtStr != null ? DateTime.tryParse(lastLoginAtStr) : null;

  //     return UserModel(
  //       id: userId ?? 0,
  //       username: username ?? "",
  //       email: email ?? "",
  //       createdAt: createdAt ?? "",
  //       updatedAt: updatedAt ?? DateTime.now(),
  //       lastLoginAt: lastLoginAt ?? DateTime.now(),
  //     );
  //   }
}
