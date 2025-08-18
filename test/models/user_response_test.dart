import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/models/auth/user_response.dart';

void main() {
  group('UserModel', () {
    test('インスタンスが正しく作成される', () {
      final user = UserModel(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-02T00:00:00Z',
        lastLoginAt: '2024-01-03T00:00:00Z',
      );

      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
    });

    test('fromJson / toJson が正しく動作する', () {
      final json = {
        "id": 2,
        "username": "user2",
        "email": "user2@example.com",
        "created_at": "2024-01-01T10:00:00Z",
        "updated_at": "2024-01-02T10:00:00Z",
        "last_login_at": "2024-01-03T10:00:00Z",
      };

      final user = UserModel.fromJson(json);
      final backToJson = user.toJson();

      expect(backToJson['id'], 2);
      expect(backToJson['username'], 'user2');
      expect(backToJson['email'], 'user2@example.com');
    });

    test('copyWith が正しく動作する', () {
      final user = UserModel(
        id: 3,
        username: 'original',
        email: 'original@example.com',
        createdAt: 'a',
        updatedAt: 'b',
        lastLoginAt: 'c',
      );

      final modified = user.copyWith(username: 'modified');

      expect(modified.username, 'modified');
      expect(modified.id, 3);
    });
  });

  group('UserResponse', () {
    final user = UserModel(
      id: 10,
      username: 'user10',
      email: 'user10@example.com',
      createdAt: '2024-01-01',
      updatedAt: '2024-01-02',
      lastLoginAt: '2024-01-03',
    );

    test('インスタンスが正しく作成される', () {
      final response = UserResponse(
        accessToken: 'abc123',
        accessTokenExpiresAt: '2024-12-01T00:00:00Z',
        refreshToken: 'xyz789',
        refreshTokenExpiresAt: '2025-01-01T00:00:00Z',
        user: user,
      );

      expect(response.accessToken, 'abc123');
      expect(response.user?.username, 'user10');
    });

    test('fromJson / toJson が正しく動作する', () {
      final json = {
        "access_token": "token123",
        "access_token_expires_at": "2024-12-01T00:00:00Z",
        "refresh_token": "refresh123",
        "refresh_token_expires_at": "2025-01-01T00:00:00Z",
        "user": {
          "id": 11,
          "username": "jsonuser",
          "email": "json@example.com",
          "created_at": "2024-01-01",
          "updated_at": "2024-01-02",
          "last_login_at": "2024-01-03",
        }
      };

      final res = UserResponse.fromJson(json);
      final backToJson = res.toJson();

      expect(res.user?.username, 'jsonuser');
      expect(backToJson['user']['email'], 'json@example.com');
    });

    test('copyWith が正しく動作する', () {
      final response = UserResponse(
        accessToken: 'old',
        accessTokenExpiresAt: 'exp',
        refreshToken: 'refresh',
        refreshTokenExpiresAt: 'refexp',
        user: user,
      );

      final updated = response.copyWith(accessToken: 'newToken');

      expect(updated.accessToken, 'newToken');
      expect(updated.user?.id, 10);
    });
  });
}
