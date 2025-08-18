

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/message/message.dart';
import 'package:rag_faq_document/services/message/message_service.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late MockMessageRepository mockRepo;
  late MessageService messageService;

  setUp(() {
    mockRepo = MockMessageRepository();
    messageService = MessageService(repo: mockRepo);
  });

  group('MessageService', () {
    test('listMessage success', () async {
      final messages = [
        Message(id: 1, message: 'Hello', sessionId: 1, createdAt: DateTime.now(), isUser: true),
        Message(id: 2, message: 'Hi', sessionId: 1, createdAt: DateTime.now(), isUser: false),
      ];

      when(mockRepo.listMessage(sessionId: 1)).thenAnswer((_) async => messages);

      final result = await messageService.listMessage(sessionId: 1);
      expect(result, equals(messages));
      verify(mockRepo.listMessage(sessionId: 1)).called(1);
    });

    test('listMessage throws CustomError.server on HttpErrorException', () async {
      when(mockRepo.listMessage(sessionId: 1)).thenThrow(
        HttpErrorException(message: 'Not Found', statusCode: 404),
      );

      expect(
        () => messageService.listMessage(sessionId: 1),
        throwsA(isA<CustomError>()),
      );
    });

    test('listMessage throws CustomError.other on unknown error', () async {
      when(mockRepo.listMessage(sessionId: 1)).thenThrow(Exception('Unknown'));

      expect(
        () => messageService.listMessage(sessionId: 1),
        throwsA(isA<CustomError>()),
      );
    });

    test('postMessage success', () async {
      final now = DateTime.now();
      final message = Message(
        id: 1,
        message: 'Hello AI',
        sessionId: 1,
        isUser:true,
        createdAt: now,
      );

      when(mockRepo.postMessage(
        message: 'Hello AI',
        sessionId: 1,
        documentId: 2,
        title: 'test',
      )).thenAnswer((_) async => message);

      final result = await messageService.postMessage(
        message: 'Hello AI',
        sessionId: 1,
        documentId: 2,
        title: 'test',
      );

      expect(result, equals(message));
      verify(mockRepo.postMessage(
        message: 'Hello AI',
        sessionId: 1,
        documentId: 2,
        title: 'test',
      )).called(1);
    });

    test('postMessage throws CustomError.server on HttpErrorException', () async {
      when(mockRepo.postMessage(
        message: anyNamed('message'),
        sessionId: anyNamed('sessionId'),
        documentId: anyNamed('documentId'),
        title: anyNamed('title'),
      )).thenThrow(HttpErrorException(message: 'Unauthorized', statusCode: 401));

      expect(
        () => messageService.postMessage(
          message: 'Hi',
          sessionId: 1,
          documentId: 2,
          title: 'fail',
        ),
        throwsA(isA<CustomError>()),
      );
    });

    test('postMessage throws CustomError.other on unknown error', () async {
      when(mockRepo.postMessage(
        message: anyNamed('message'),
        sessionId: anyNamed('sessionId'),
        documentId: anyNamed('documentId'),
        title: anyNamed('title'),
      )).thenThrow(Exception('Something went wrong'));

      expect(
        () => messageService.postMessage(
          message: 'Hi',
          sessionId: 1,
          documentId: 2,
          title: 'fail',
        ),
        throwsA(isA<CustomError>()),
      );
    });
  });
}