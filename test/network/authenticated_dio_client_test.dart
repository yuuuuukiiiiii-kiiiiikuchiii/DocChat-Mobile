import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  test('access あり → Authorization ヘッダが付与される', () async {
    final storage = MockLocalStorage();
    when(storage.access).thenReturn('ACCESS_1');

    final client = AuthenticatedDioClient(
      storage: storage,
      baseUrl: 'https://api.example.com',
      onUnauthorized: () {},
      deviceInfoGetter: () async => 'dev',
    );

    final adapter = _OkAdapter(data: {'ok': true}, statusCode: 200);
    client.dio.httpClientAdapter = adapter;

    await client.dio.get('/profile');

    expect(adapter.lastHeaders?['Authorization'], 'Bearer ACCESS_1');
  });

  test('access なし → Authorization ヘッダは付かない', () async {
    final storage = MockLocalStorage();
    when(storage.access).thenReturn(null);

    final client = AuthenticatedDioClient(
      storage: storage,
      baseUrl: 'https://api.example.com',
      onUnauthorized: () {},
      deviceInfoGetter: () async => 'dev',
    );

    final adapter = _OkAdapter(data: {'ok': true}, statusCode: 200);
    client.dio.httpClientAdapter = adapter;

    await client.dio.get('/profile');

    expect(adapter.lastHeaders?.containsKey('Authorization'), isFalse);
  });

  test('最初401 → refresh成功 → 新トークンで再送(200)', () async {
    final storage = MockLocalStorage();
    // 初回Authorizationは OLD
    when(storage.access).thenReturn('OLD');
    // refreshトークンは有効
    when(storage.loadRefresh()).thenAnswer((_) async => 'REFRESH_OK');
    // 保存はvoid
    when(storage.setAccess(any)).thenAnswer((inv) async {
  final newVal = inv.positionalArguments[0] as String;
  when(storage.access).thenReturn(newVal);
});
when(storage.saveRefresh(any)).thenAnswer((_) async {});

    // refresh API の Dio をモックし、成功レスを返す
    final mockRefreshDio = MockDio();
    when(mockRefreshDio.post(
      '/tokens/renew_access',
      data: anyNamed('data'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/tokens/renew_access'),
          statusCode: 200,
          data: {
            'access_token': 'NEW_ACCESS',
            'refresh_token': 'NEW_REFRESH',
          },
        ));

    bool unauthorizedCalled = false;

    final client = AuthenticatedDioClient(
      storage: storage,
      baseUrl: 'https://api.example.com',
      onUnauthorized: () { unauthorizedCalled = true; },
      deviceInfoGetter: () async => 'dev',
      refreshDioFactory: (o) => mockRefreshDio, // ← 注入ポイント
    );

    // 1回目401 → 2回目200 を返すアダプタ
    final adapter = _First401Then200Adapter();
    client.dio.httpClientAdapter = adapter;

    final res = await client.dio.get('/profile');
    expect(res.statusCode, 200);
    expect(unauthorizedCalled, isFalse);

    // refresh 保存が呼ばれている
    verify(storage.setAccess('NEW_ACCESS')).called(1);
    verify(storage.saveRefresh('NEW_REFRESH')).called(1);

    // 再送された時のAuthorizationが NEW になっている
    expect(adapter.lastHeaders?['Authorization'], 'Bearer NEW_ACCESS');
  });

  test('401時 refresh失敗 → storage.clear + onUnauthorized(一回だけ)', () async {
    final storage = MockLocalStorage();
    when(storage.access).thenReturn('OLD');
    when(storage.loadRefresh()).thenAnswer((_) async => 'REFRESH_EXISTS');
    when(storage.clear()).thenAnswer((_) async {});

    // refresh API を常に失敗させる
    final mockRefreshDio = MockDio();
    when(mockRefreshDio.post(
      any,
      data: anyNamed('data'),
      options: anyNamed('options'),
    )).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/tokens/renew_access'),
      response: Response(requestOptions: RequestOptions(path: ''), statusCode: 400),
      type: DioExceptionType.badResponse,
    ));

    int unauthorizedCount = 0;

    final client = AuthenticatedDioClient(
      storage: storage,
      baseUrl: 'https://api.example.com',
      onUnauthorized: () { unauthorizedCount++; },
      deviceInfoGetter: () async => 'dev',
      refreshDioFactory: (o) => mockRefreshDio,
    );

    // いつでも401を返すアダプタ
    client.dio.httpClientAdapter = _Always401Adapter();

    // 401 → refresh失敗 → _failUnauthorized（以降の処理はアプリ依存なので catch で握りつぶし）
    try {
      await client.dio.get('/any');
    } catch (_) {}

    verify(storage.clear()).called(1);
    expect(unauthorizedCount, 1); // ダイアログ多重抑止が効いている想定
  });
}

/// シンプルな固定応答アダプタ（テスト用）
class _OkAdapter implements HttpClientAdapter {
  final dynamic data;
  final int statusCode;
  Map<String, dynamic>? lastHeaders;

  _OkAdapter({required this.data, required this.statusCode});

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future? cancelFuture,
  ) async {
    lastHeaders = Map.from(options.headers);

    // JSONエンコード
    final encoded = data is String ? data : jsonEncode(data);

    final body = ResponseBody.fromString(
      encoded,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
    return body;
  }
}

/// 1回目401、2回目200を返すテスト用アダプタ
class _First401Then200Adapter implements HttpClientAdapter {
  bool first = true;
  Map<String, dynamic>? lastHeaders;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<List<int>>? _,
    Future? __,
  ) async {
    if (first) {
      first = false;
      throw DioException(
        requestOptions: o,
        response: Response(requestOptions: o, statusCode: 401, data: {'error': 'unauthorized'}),
        type: DioExceptionType.badResponse,
      );
    }
    lastHeaders = Map.from(o.headers);
    return ResponseBody.fromString(
      jsonEncode({'ok': true}),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }
}

class _Always401Adapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<List<int>>? _,
    Future? __,
  ) async {
    throw DioException(
      requestOptions: o,
      response: Response(requestOptions: o, statusCode: 401),
      type: DioExceptionType.badResponse,
    );
    // 通らない
  }
}
