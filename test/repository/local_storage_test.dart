import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  late LocalStorage localStorage;

  setUp(() {
    // テストごとに初期化
    SharedPreferences.setMockInitialValues({});
    localStorage = LocalStorage();
  });

  test('saveTokens and getToken should store and retrieve token values correctly', () async {
    await localStorage.saveTokens(
      accessToken: 'access123',
      accessTokenExpiresAt: '2025-01-01T00:00:00Z',
      refreshToken: 'refresh456',
      refreshTokenExpiresAt: '2026-01-01T00:00:00Z',
    );

    final token = await localStorage.getToken();

    expect(token.accessToken, 'access123');
    expect(token.refreshToken, 'refresh456');
    expect(token.accessTokenExpiresAt?.toIso8601String(), '2025-01-01T00:00:00.000Z');
    expect(token.refreshTokenExpiresAt?.toIso8601String(), '2026-01-01T00:00:00.000Z');
  });

  test('clearTokens should remove all token values', () async {
    await localStorage.saveTokens(
      accessToken: 'access',
      accessTokenExpiresAt: '2025-01-01T00:00:00Z',
      refreshToken: 'refresh',
      refreshTokenExpiresAt: '2026-01-01T00:00:00Z',
    );

    await localStorage.clearTokens();

    final token = await localStorage.getToken();
    expect(token.accessToken, isNull);
    expect(token.refreshToken, isNull);
  });

  test('getAccessToken and getRefreshToken should return correct values', () async {
    await localStorage.saveTokens(
      accessToken: 'token123',
      accessTokenExpiresAt: '2025-01-01T00:00:00Z',
      refreshToken: 'token456',
      refreshTokenExpiresAt: '2026-01-01T00:00:00Z',
    );

    final access = await localStorage.getAccessToken();
    final refresh = await localStorage.getRefreshToken();

    expect(access, 'token123');
    expect(refresh, 'token456');
  });

  test('setFirstLaunchComplete should store the boolean flag', () async {
    await localStorage.setFirstLaunchComplete();

    final token = await localStorage.getToken();
    expect(token.firstLaunchCompleted, isTrue);
  });

  test('saveUser stores all user fields correctly', () async {
    await localStorage.saveUser(
      id: 1,
      username: 'kikuchi',
      email: 'kikuchi@example.com',
      createdAt: '2023-01-01',
      updatedAt: '2023-01-02',
      lastLoginAt: '2023-01-03',
    );

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('user_id'), 1);
    expect(prefs.getString('user_name'), 'kikuchi');
    expect(prefs.getString('email'), 'kikuchi@example.com');
    expect(prefs.getString('created_at'), '2023-01-01');
    expect(prefs.getString('updated_at'), '2023-01-02');
    expect(prefs.getString('lastLogin_at'), '2023-01-03');
  });
}
