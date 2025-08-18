import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/chat/chat.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/services/chat/chat_service.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late MockChatRepository mockRepo;
  late ChatService chatService;

  setUp(() {
    mockRepo = MockChatRepository();
    chatService = ChatService(repo: mockRepo);
  });

  group('ChatService', () {
    test('getChat throws CustomError.server with correct details', () async {
      when(
        mockRepo.getChat(id: 1),
      ).thenThrow(HttpErrorException(message: 'Unauthorized', statusCode: 401));

      expect(
        () => chatService.getChat(id: 1),
        throwsA(
          isA<ServerError>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.message, 'message', 'Unauthorized'),
        ),
      );
    });

    test('listChat success', () async {
      final now = DateTime.now();
      final chats = [
        Chat(
          id: 1,
          title: 'Chat 1',
          documentId: 1,
          createdAt: now,
          userId: 1,
          updatedAt: now,
        ),
        Chat(
          id: 2,
          title: 'Chat 2',
          documentId: 1,
          createdAt: now,
          userId: 2,
          updatedAt: now,
        ),
      ];

      when(
        mockRepo.listChats(pageId: 1, pageSize: 5),
      ).thenAnswer((_) async => chats);

      final result = await chatService.listChat(pageId: 1);
      expect(result, chats);
      verify(mockRepo.listChats(pageId: 1, pageSize: 5)).called(1);
    });

    test('listChat throws CustomError.server on HttpErrorException', () async {
      when(
        mockRepo.listChats(pageId: 1, pageSize: 5),
      ).thenThrow(HttpErrorException(message: 'Not Found', statusCode: 404));

      expect(
        () => chatService.listChat(pageId: 1),
        throwsA(isA<CustomError>()),
      );
    });

    test('getChat success', () async {
      final now = DateTime.now();
      final chat = Chat(
        id: 1,
        title: 'Chat 1',
        documentId: 1,
        createdAt: now,
        userId: 1,
        updatedAt: now,
      );

      when(mockRepo.getChat(id: 1)).thenAnswer((_) async => chat);

      final result = await chatService.getChat(id: 1);
      expect(result, chat);
      verify(mockRepo.getChat(id: 1)).called(1);
    });

    test('getChat throws CustomError.server on HttpErrorException', () async {
      when(
        mockRepo.getChat(id: 1),
      ).thenThrow(HttpErrorException(message: 'Unauthorized', statusCode: 401));

      expect(() => chatService.getChat(id: 1), throwsA(isA<CustomError>()));
    });

    test('createChat success', () async {
      final now = DateTime.now();
      final chat = Chat(
        id: 3,
        title: 'New Chat',
        documentId: 2,
        createdAt: now,
        userId: 1,
        updatedAt: now,
      );

      when(
        mockRepo.createChat(documentId: 2, title: 'New Chat'),
      ).thenAnswer((_) async => chat);

      final result = await chatService.createChat(
        title: 'New Chat',
        documentId: 2,
      );
      expect(result, chat);
      verify(mockRepo.createChat(documentId: 2, title: 'New Chat')).called(1);
    });

    test(
      'createChat throws CustomError.server on HttpErrorException',
      () async {
        when(mockRepo.createChat(documentId: 2, title: 'Fail Chat')).thenThrow(
          HttpErrorException(message: 'Bad Request', statusCode: 400),
        );

        expect(
          () => chatService.createChat(title: 'Fail Chat', documentId: 2),
          throwsA(isA<CustomError>()),
        );
      },
    );
  });
}
