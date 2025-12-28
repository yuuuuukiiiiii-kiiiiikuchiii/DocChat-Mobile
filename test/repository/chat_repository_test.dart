// test/repository/chat_repository_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';

import '../mocks/mocks.mocks.dart';

import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';
import 'package:rag_faq_document/repository/chat/chat_repository.dart';
import 'package:rag_faq_document/models/chat/chat.dart';


void main() {
  late MockLocalStorage storage;
  late AuthenticatedDioClient client;
  late ChatRepository repo;

  setUp(() {
    storage = MockLocalStorage();

    // デフォルト：Bearer付けない／refresh走らせない
    // （NiceMockなので未スタブでも null だが、明示で読みやすく）
    when(storage.access).thenReturn(null);
    when(storage.loadRefresh()).thenAnswer((_) async => null);

    client = AuthenticatedDioClient(
      storage: storage,
      baseUrl: 'https://api.example.com',
      onUnauthorized: () {},
      deviceInfoGetter: () async => 'dev',
    );

    // 非200でも Dio が例外を投げず Response を返す → Repository側の分岐をテスト可
    client.dio.options.validateStatus = (_) => true;

    repo = ChatRepository(client: client);
  });

  group('listChats', () {
    test('200 → List<Chat> を返す & クエリが渡る', () async {
      final adapter = _FixedAdapter(
        statusCode: 200,
        data: [
          {'id': 1, 'title': 'A'},
          {'id': 2, 'title': 'B'},
        ],
      );
      client.dio.httpClientAdapter = adapter;

      final res = await repo.listChats(pageId: 3, pageSize: 20);

      expect(res, isA<List<Chat>>());
      expect(res.length, 2);
      expect(res[0].id, 1);
      expect(res[0].title, 'A');

      // リクエスト検証（任意）
      expect(adapter.lastPath, '/chats');
      expect(adapter.lastMethod, 'GET');
      expect(adapter.lastQuery?['page_id'], '3');
      expect(adapter.lastQuery?['page_size'], '20');
    });

    test('非200 → HttpErrorException', () async {
      final adapter = _FixedAdapter(
        statusCode: 404,
        data: {'error': 'not found'},
      );
      client.dio.httpClientAdapter = adapter;

      expect(
        () => repo.listChats(pageId: 1, pageSize: 10),
        throwsA(
          isA<HttpErrorException>()
              .having((e) => e.statusCode, 'status', 404)
              .having((e) => e.message, 'message', 'not found'),
        ),
      );
    });
  });

  group('getChat', () {
    test('200 → Chat を返す', () async {
      final adapter = _FixedAdapter(
        statusCode: 200,
        data: {'id': 42, 'title': 'Hello'},
      );
      client.dio.httpClientAdapter = adapter;

      final chat = await repo.getChat(id: 42);

      expect(chat.id, 42);
      expect(chat.title, 'Hello');

      expect(adapter.lastPath, '/chats/42');
      expect(adapter.lastMethod, 'GET');
    });

    test('非200 → HttpErrorException', () async {
      final adapter = _FixedAdapter(
        statusCode: 500,
        data: {'error': 'server'},
      );
      client.dio.httpClientAdapter = adapter;

      expect(
        () => repo.getChat(id: 9),
        throwsA(
          isA<HttpErrorException>()
              .having((e) => e.statusCode, 'status', 500)
              .having((e) => e.message, 'message', 'server'),
        ),
      );
    });
  });

  group('createChat', () {
    test('200 → Chat を返す & Body が送られる', () async {
      final adapter = _FixedAdapter(
        statusCode: 200,
        data: {'id': 7, 'title': 'New Chat'},
      );
      client.dio.httpClientAdapter = adapter;

      final chat = await repo.createChat(documentId: 99, title: 'New Chat');

      expect(chat.id, 7);
      expect(chat.title, 'New Chat');

      expect(adapter.lastPath, '/chats/session');
      expect(adapter.lastMethod, 'POST');
      expect(adapter.lastData, isA<Map>());
      expect(adapter.lastData?['document_id'], 99);
      expect(adapter.lastData?['title'], 'New Chat');
    });

    test('非200 → HttpErrorException', () async {
      final adapter = _FixedAdapter(
        statusCode: 400,
        data: {'error': 'bad request'},
      );
      client.dio.httpClientAdapter = adapter;

      expect(
        () => repo.createChat(documentId: 1, title: 'x'),
        throwsA(
          isA<HttpErrorException>()
              .having((e) => e.statusCode, 'status', 400)
              .having((e) => e.message, 'message', 'bad request'),
        ),
      );
    });
  });
}

/// --------------------------------------------------
/// テスト専用：固定応答アダプタ
/// - 任意の statusCode / data を返す
/// - 直近の path / method / query / data を記録
/// --------------------------------------------------
class _FixedAdapter implements HttpClientAdapter {
  final int statusCode;
  final dynamic data;

  String? lastPath;
  String? lastMethod;
  Map<String, dynamic>? lastQuery;
  dynamic lastData;

  _FixedAdapter({required this.statusCode, required this.data});

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future? cancelFuture,
  ) async {
    lastPath = options.path;
    lastMethod = options.method;
    lastQuery = Map<String, dynamic>.from(options.queryParameters);
    lastData = options.data;

    final encoded = data is String ? data : jsonEncode(data);

    return ResponseBody.fromString(
      encoded,
      statusCode,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }
}
