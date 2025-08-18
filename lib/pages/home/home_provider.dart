import 'package:rag_faq_document/models/chat/chat.dart';
import 'package:rag_faq_document/services/chat/chat_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

const pageId = 1;

@riverpod
class ChatList extends _$ChatList {
  bool _hasMore = true;
  @override
  FutureOr<List<Chat>> build() async{
    return await fetchListChats();
  }

  Future<List<Chat>> fetchListChats() async {
    return await ref.read(chatServiceProvider).listChat(pageId: pageId);
  }


  Future<void> addChats(int nextPageId) async {
    if (!_hasMore) return;
    state = const AsyncLoading();
  
    state = await AsyncValue.guard(() async {
      final previous = state.value ?? [];

      final newChats = await ref
          .read(chatServiceProvider)
          .listChat(pageId: nextPageId);
      if (newChats.isEmpty) {
        _hasMore = false; // もうデータがないので停止
      }

      return [...previous, ...newChats];
    });
  }

  void reset() {
    _hasMore = true;
  }
}
