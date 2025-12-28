// import 'package:rag_faq_document/models/token/token.dart';
// import 'package:rag_faq_document/repository/local_storage/local_storage_provider.dart';
// import 'package:rag_faq_document/services/auth/auth_service_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'splash_screen_provider.g.dart';

// @riverpod
// class SplashScreen extends _$SplashScreen {
//   @override
//   FutureOr<TokenModel> build() async {
//     return fetchToken();
//   }

//   Future<TokenModel> fetchToken() async {
//     return ref.read(localStorageProvider).getToken();
//   }

//   // リフレッシュトークンで新しいトークンを取得
//   Future<void> renewToken(String refreshToken) async {
//     print('🧹 Renew tokens');
//     state = const AsyncLoading();
//     try {
//       final currentToken = await ref
//           .read(authServiceProvider)
//           .refreshAccessToken(refreshToken);
//       state = AsyncData(currentToken);
//     } catch (e, stackTrace) {
//       // ✅ エラー時は明示的にAsyncErrorに設定
//       state = AsyncError(e, stackTrace);
//       rethrow;
//     }
//   }
// }

