import 'package:rag_faq_document/models/message/message.dart';
import 'package:rag_faq_document/services/message/message_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_screen_provider.g.dart';

@riverpod
class ChatScreen extends _$ChatScreen {
  @override
  FutureOr<List<Message>> build(int sessionId) async{
    return await fetchListMessage(sessionId);
  }

  Future<List<Message>> fetchListMessage(int sessionId) async {
    return await ref.read(messageServiceProvider).listMessage(sessionId: sessionId);
  }

  Future<void> postMessage({required String message,required int sessionId,required int documentId,required String title}) async {
   
    final currentState = state.value ?? [];
    final nextId = currentState.isNotEmpty ? currentState.last.id + 1 : 1;
    final userMessage = Message.add(
      id: nextId,
      sessionId: sessionId,
      message: message,
      isUser: true,
      createdAt: DateTime.now(),
    );

    // 楽観的に表示
    state = AsyncData([...currentState, userMessage]);

     // 実際にAPIからAIの回答を取得
    state = await AsyncValue.guard(() async {
      final aiMessage = await ref.read(messageServiceProvider).postMessage(
            message: message,
            sessionId: sessionId,
            documentId: documentId,
            title: title,
          );
      return [...currentState, userMessage, aiMessage];
    });
  }
}