import 'dart:async';

import 'package:rag_faq_document/models/document/document_status_response/document_status_response.dart';
import 'package:rag_faq_document/services/load/load_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_screen_provider.g.dart';

@riverpod
class LoadingScreen extends _$LoadingScreen {
  Timer? _timer;
  @override
  FutureOr<DocumentStatusResponse> build(int documentId) async {
    // Provider が破棄されたときに Timer を止める
    ref.onDispose(() {
      _timer?.cancel();
    });

    // 画面に入ったタイミングで processing に変更
    final service = ref.read(loadServiceProvider);

    state = const AsyncLoading();

    try {
      final res = await service.uploadComplete(documentId: documentId);

      // 最初のレスポンスを反映
      state = AsyncData(res);

      // ポーリング開始
      _startPolling(documentId);

      return res;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  void _startPolling(int documentId) {
    _timer?.cancel();

    final service = ref.read(loadServiceProvider);

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final current = state;

      if (current is AsyncError) {
        timer.cancel();
        return;
      }

      try {
        final res = await service.getDocumentStatus(documentId: documentId);
        state = AsyncData(res);

        if (res.status == 'completed') {
          timer.cancel();
        }
      } catch (e, st) {
        state = AsyncError(e, st);
        timer.cancel();
      }
    });
  }
}
