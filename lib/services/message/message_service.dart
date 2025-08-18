import 'package:rag_faq_document/exceptions/http_exception.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/models/message/message.dart';
import 'package:rag_faq_document/repository/handle_exception.dart';
import 'package:rag_faq_document/repository/message/message_repository.dart';
import 'package:rag_faq_document/utils/utils.dart';

class MessageService {
  final MessageRepository repo;
  MessageService({required this.repo});

  Future<List<Message>> listMessage({required int sessionId}) async {
    try {
      final messages = await repo.listMessage(sessionId: sessionId);
      return messages;
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

  Future<Message> postMessage({
    required String message,
    required int sessionId,
    required int documentId,
    required String title
  }) async {
    try {
      final mes = await repo.postMessage(message: message, sessionId: sessionId, documentId: documentId, title: title);
      return mes;
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
