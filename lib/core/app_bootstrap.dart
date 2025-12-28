import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/core/app_state.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage_provider.dart';
import 'package:rag_faq_document/services/auth/auth_service_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appStartProvider = FutureProvider((ref) async {
  //オンボディング処理
  final prefs = await SharedPreferences.getInstance();
  final seen = prefs.getBool("onb_done") ?? false;
  if (!seen) {
    ref.read(onbStatusProvider.notifier).state = OnbStatus.needed;
    ref.read(authStatusProvider.notifier).state = AuthStatus.unauthenticated;
    return;
  }
  ref.read(onbStatusProvider.notifier).state = OnbStatus.done;

  //認証ブート
  final storage = ref.read(localStorageProvider);
  final refresh = await storage.loadRefresh();
  if (refresh == null || refresh.isEmpty) {
    ref.read(authStatusProvider.notifier).state = AuthStatus.unauthenticated;
    return;
  }

  try {
    await ref
        .read(authServiceProvider)
        .refreshAccessToken(refresh)
        .timeout(const Duration(seconds: 3)); // 無限スプラッシュ防止

    ref.read(authStatusProvider.notifier).state = AuthStatus.authenticated;
    ref.read(bootErrorProvider.notifier).state = null; // エラーは無し
  } on CustomError catch (e) {
    ref.read(authStatusProvider.notifier).state = AuthStatus.unauthenticated;
    ref.read(bootErrorProvider.notifier).state = e; // ← この内容をLoginで出す
  } catch (e) {
    ref.read(authStatusProvider.notifier).state = AuthStatus.unauthenticated;
    ref.read(bootErrorProvider.notifier).state = CustomError.unknown(
      message: '起動時エラー: $e',
    );
  }
});
