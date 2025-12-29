import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_faq_document/config/router/router_provider.dart';
import 'package:rag_faq_document/core/app_bootstrap.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // スプラッシュスクリーンを維持
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  print('✅ dotenv loaded, BASEURL: ${dotenv.env["BASEURL"]}');
  // エラーハンドリングの設定
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('🔴 Flutter error: ${details.exception}');
  };

  runApp(ProviderScope(child: const MyApp()));
  //FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(appStartProvider, (_, next) {
      next.whenData((_) {
        // ルーティングのredirectが確定した“次フレーム”で外すとチラつかない
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FlutterNativeSplash.remove();
        });
      });
    });
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'rag_faq_doc',
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: Color.fromRGBO(189, 176, 176, 1)),
      routerConfig: router,
    );
  }
}
