import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/chat/chat.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/repository/chat/chat_repository.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/utils/utils.dart';

const pageSize = 5;

class ChatService {
  final ChatRepository repo;
  ChatService({required this.repo});

  Future<List<Chat>> listChat({required int pageId}) async {
    try {
      final chats = await repo.listChats(pageId: pageId, pageSize: pageSize);
      return chats;
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

  Future<Chat> getChat({required int id}) async {
    try {
      final chat = await repo.getChat(id: id);
      return chat;
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

  Future<Chat> createChat({
    required String title,
    required int documentId,
  }) async {
    try {
      final chat = repo.createChat(documentId: documentId, title: title);
      return chat;
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
}
