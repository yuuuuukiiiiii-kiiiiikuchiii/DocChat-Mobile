import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/config/router/router_provider.dart';
import 'package:rag_faq_document/core/app_state.dart';
import 'package:rag_faq_document/repository/dio/authenticated_dio_client.dart';
import 'package:rag_faq_document/repository/local_storage/local_storage_provider.dart';
import 'package:rag_faq_document/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authenticated_dio_client_provider.g.dart';

@riverpod
AuthenticatedDioClient authenticatedDioClient(Ref ref) {
  final storage = ref.watch(localStorageProvider);
  final baseUrl = dotenv.env["BASEURL"];
  final getDeviceInfoFn = DeviceInfoWrapperImpl().getDeviceName;

  return AuthenticatedDioClient(
    storage: storage,
    baseUrl: baseUrl!,
    onUnauthorized: () async {
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        await showCupertinoDialog(
          context: context,
          builder:
              (_) => CupertinoAlertDialog(
                title: const Text("セッション切れ"),
                content: const Text("セッションの有効期限が切れました。\n再度ログインしてください。"),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      ref.read(authStatusProvider.notifier).state = AuthStatus.unauthenticated;
                      Navigator.of(context).pop(); // ダイアログを閉じる
                      GoRouter.of(
                        context,
                      ).goNamed(RouteNames.signin); // ログイン画面へ
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      } else {
        print('❗ context is null. Cannot redirect to login.');
      }
    }, deviceInfoGetter: ()=>getDeviceInfoFn(),
  );
}
