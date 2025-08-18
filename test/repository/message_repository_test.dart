
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/repository/message/message_repository.dart';


import '../mocks/mocks.mocks.dart';


void main() {
  late MockDio mockDio;
  late MockAuthenticatedDioClient mockClient;
  late MessageRepository repository;

  setUp(() {
    mockDio = MockDio();
    mockClient = MockAuthenticatedDioClient();
    when(mockClient.dio).thenReturn(mockDio);

    repository = MessageRepository(client: mockClient);
  });

  group('postMessage', () {
    test('returns Message on success', () async {
      when(mockDio.post(
        '/messages/ask/1',
        data: {
          "message": "Hello",
          "document_id": 10,
          "title": "Test",
        },
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/messages/ask/1'),
            statusCode: 200,
            data: {
              "id": 1,
              "session_id": 1,
              "is_user": true,
              "message": "Hello",
              "created_at": "2024-01-01T00:00:00Z",
            },
          ));

      final result = await repository.postMessage(
        message: "Hello",
        sessionId: 1,
        documentId: 10,
        title: "Test",
      );

      expect(result.id, 1);
      expect(result.message, "Hello");
    });

    test('throws HttpErrorException on failure', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/messages/ask/1'),
            statusCode: 500,
            data: {'error': 'Internal server error'},
          ));

      expect(
        () => repository.postMessage(
          message: "Hi",
          sessionId: 1,
          documentId: 10,
          title: "Error Test",
        ),
        throwsA(isA<HttpErrorException>()),
      );
    });
  });

  group('listMessage', () {
    test('returns list of Message on success', () async {
      when(mockDio.get('/messages/1')).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/messages/1'),
            statusCode: 200,
            data: [
              {
                "id": 1,
                "session_id": 1,
                "is_user": true,
                "message": "Hi",
                "created_at": "2024-01-01T00:00:00Z",
              },
              {
                "id": 2,
                "session_id": 1,
                "is_user": false,
                "message": "Hello!",
                "created_at": "2024-01-01T00:00:01Z",
              },
            ],
          ));

      final result = await repository.listMessage(sessionId: 1);

      expect(result.length, 2);
      expect(result[0].isUser, true);
      expect(result[1].message, "Hello!");
    });

    test('throws HttpErrorException on failure', () async {
      when(mockDio.get('/messages/1')).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/messages/1'),
            statusCode: 404,
            data: {'error': 'Session not found'},
          ));

      expect(
        () => repository.listMessage(sessionId: 1),
        throwsA(isA<HttpErrorException>()),
      );
    });
  });}