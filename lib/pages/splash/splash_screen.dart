// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:go_router/go_router.dart';
// import 'package:rag_faq_document/config/router/route_names.dart';
// import 'package:rag_faq_document/models/error/custom_error.dart';
// import 'package:rag_faq_document/models/token/token.dart';
// import 'package:rag_faq_document/pages/splash/splash_screen_provider.dart';
// import 'package:rag_faq_document/utils/error_dialog.dart';



// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   bool firstSpalsh = false;
//   bool _hasShownErrorDialog = false; // 🔒追加フラグ


//   @override
//   Widget build(BuildContext context) {
//     print('🔄 SplashScreen build');

//     ref.listen<AsyncValue<TokenModel>>(splashScreenProvider, (prev, next) {
//       next.whenOrNull(
//         data: (TokenModel token) {
//           if (firstSpalsh == false) {
//             setState(() {
//               firstSpalsh = true;
//               _hasShownErrorDialog = false; // ✅ 成功したらリセット
//             });
//             _navigateToNext(token);
//           } else {
//             null;
//           }
//         },
//         error: (error, stackTrace) {
//            if (!mounted || _hasShownErrorDialog) return; // ❗既に表示してたら何もしない
//            _hasShownErrorDialog = true; // ✅ 最初の一度だけ通す
//           bool is401Error = false;
//           if (error is ServerError) {
//             is401Error = error.statusCode == 401;
//           }
//           if (is401Error) {
//             errorDialog(
//               context,
//               "セッション切れです。",
//               error as CustomError,
//               RouteNames.signin,
//             );
//           } else {
//             errorDialog(context, "データを取得失敗しました。", error as CustomError, null);
//           }
//         },
//       );
//     });

//     final tokenState = ref.watch(splashScreenProvider);

//     return Scaffold(
//       body: tokenState.maybeWhen(
//         error: (error, _) {
//           if (error is ServerError && error.statusCode == 401) {
//             return const SizedBox.shrink(); // セッション切れはダイアログ表示のためUI非表示
//           } else {
//             return _buildRetryButton();
//           }
//         },
//         orElse: () => _buildLoadingSpinner(),
//       ),
//     );
//   }

//   Widget _buildRetryButton() {
//     return Padding(
//       padding: const EdgeInsets.all(30.0),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("データの取得に失敗しました。", style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 20),
//             OutlinedButton(
//               onPressed: () {
//                 ref.invalidate(splashScreenProvider);
//               },
//               child: const Text("再度更新", style: TextStyle(fontSize: 20)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingSpinner() {
//     return const Center(
//       child: SpinKitFadingCircle(color: Colors.grey, size: 50.0),
//     );
//   }

//   void _navigateToNext(TokenModel token) async {
//     final gorouter = GoRouter.of(context);
//     print('🚀 Navigating from Splash screen');

//     if (token.firstLaunchCompleted == false) {
//       print("firstLaunchCompleted:false");
//       GoRouter.of(context).goNamed(RouteNames.onboarding);
//       return;
//     }

//     if (token.accessToken == null) {
//       //await Future.delayed(const Duration(seconds: 2));
//       print("accessToken:null");
//       gorouter.goNamed(RouteNames.signin);
//       return;
//     }

//     final now = DateTime.now();
//     if (token.accessTokenExpiresAt != null &&
//         now.isBefore(token.accessTokenExpiresAt!)) {
//       print("accessToken:有効");
//       GoRouter.of(context).goNamed(RouteNames.home);
//       return;
//     }

//     if (token.accessTokenExpiresAt != null &&
//         now.isAfter(token.accessTokenExpiresAt!) &&
//         token.refreshToken != null) {
//       print("accessToken:無効 && 有効期限切れ");
      
//       await _refreshToken(token.refreshToken!);
//       return;
//     }

//     GoRouter.of(context).goNamed(RouteNames.signin);
//   }

  

//   Future<void> _refreshToken(String refreshToken) async {
//     print('🔄 Starting token refresh');
//     try {
//       await ref.read(splashScreenProvider.notifier).renewToken(refreshToken);

//       if (mounted) {
//         print('✅ Refresh successful, navigating to home');
//         GoRouter.of(context).goNamed(RouteNames.home);
//       }
//     } catch (e) {
//       print('❌ Token refresh failed in _refreshToken: $e');
//       if (mounted) {
//         setState(() {
//               firstSpalsh = false;
//             });
//       }
//     }
//   }
// }
