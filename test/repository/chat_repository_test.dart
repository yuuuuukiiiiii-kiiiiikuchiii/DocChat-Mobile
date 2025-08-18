import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/repository/chat/chat_repository.dart';

import '../mocks/mocks.mocks.dart';


void main() {
  late MockDio mockDio;
  late MockAuthenticatedDioClient mockClient;
  late ChatRepository repository;

  setUp(() {
    mockDio = MockDio();
    mockClient = MockAuthenticatedDioClient();

    // モックDioを返すようにスタブ
    when(mockClient.dio).thenReturn(mockDio);

    repository = ChatRepository(client: mockClient);
  });

  group('createChat', () {
  test('returns Chat on success', () async {
    when(mockDio.post(
      '/chats/session',
      data: {
        'document_id': 100,
        'title': 'New Chat',
      },
    )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/chats/session'),
        statusCode: 200,
        data: {
          'id': 3,
          'user_id': 42,
          'document_id': 100,
          'title': 'New Chat',
          'created_at': '2024-01-03T00:00:00Z',
          'updated_at': '2024-01-03T00:00:00Z',
        },
      ),
    );

    final result = await repository.createChat(documentId: 100, title: 'New Chat');
    expect(result.id, 3);
    expect(result.title, 'New Chat');
  });

  test('throws HttpErrorException on failure', () async {
    when(mockDio.post(
      '/chats/session',
      data: anyNamed('data'),
    )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/chats/session'),
        statusCode: 500,
        data: {'error': 'Server error'},
      ),
    );

    expect(
      () => repository.createChat(documentId: 100, title: 'New Chat'),
      throwsA(isA<HttpErrorException>()),
    );
  });
});


  group('listChats', () {
  test('returns list of Chat on success', () async {
    when(mockDio.get(
      '/chats',
      queryParameters: anyNamed('queryParameters'),
    )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/chats'),
        statusCode: 200,
        data: [
          {
            'id': 1,
            'user_id': 42,
            'document_id': 100,
            'title': 'Chat 1',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
          {
            'id': 2,
            'user_id': 42,
            'document_id': 101,
            'title': 'Chat 2',
            'created_at': '2024-01-02T00:00:00Z',
            'updated_at': '2024-01-02T00:00:00Z',
          },
        ],
      ),
    );

    final result = await repository.listChats(pageId: 1, pageSize: 10);
    expect(result.length, 2);
    expect(result[0].title, 'Chat 1');
    expect(result[1].title, 'Chat 2');
  });

  test('throws HttpErrorException on failure', () async {
    when(mockDio.get(
      '/chats',
      queryParameters: anyNamed('queryParameters'),
    )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/chats'),
        statusCode: 400,
        data: {'error': 'Bad request'},
      ),
    );

    expect(
      () => repository.listChats(pageId: 1, pageSize: 10),
      throwsA(isA<HttpErrorException>()),
    );
  });
});


  group('getChat', () {
    test('returns Chat on success', () async {
      when(mockDio.get('/chats/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/chats/1'),
          statusCode: 200,
          data: {
            'id': 1,
            'user_id': 42,
            'document_id': 100,
            'title': 'Single Chat',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-02T00:00:00Z',
          },
        ),
      );

      final result = await repository.getChat(id: 1);
      expect(result.id, 1);
      expect(result.title, 'Single Chat');
    });

    test('throws HttpErrorException on failure', () async {
      when(mockDio.get('/chats/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/chats/1'),
          statusCode: 404,
          data: {'error': 'Not found'},
        ),
      );

      expect(
        () => repository.getChat(id: 1),
        throwsA(isA<HttpErrorException>()),
      );
    });
  });
}
