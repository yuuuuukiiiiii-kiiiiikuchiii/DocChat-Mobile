import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';


void main() {
  testWidgets('shows CupertinoAlertDialog and navigates on OK press', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (_, __) => const Scaffold(body: Text('Home')),
        ),
        GoRoute(
          path: '/next',
          name: 'next',
          builder: (_, __) => const Scaffold(body: Text('Next')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    await tester.pumpAndSettle();

    final error = CustomError.unknown(
      message: 'Something went wrong',
      userMessage: 'ユーザー向けのエラーメッセージ',
    );

    final BuildContext context = tester.element(find.text('Home'));

    errorDialog(
      context,
      'エラーが発生しました',
      error,
      'next',
    );

    await tester.pumpAndSettle();

    expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    expect(find.text('エラーが発生しました'), findsOneWidget);
    expect(find.text('ユーザー向けのエラーメッセージ'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Next'), findsOneWidget);

    // 🔁 ここでリセットが必要！
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('shows AlertDialog and navigates on OK press', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (_, __) => const Scaffold(body: Text('Home')),
        ),
        GoRoute(
          path: '/next',
          name: 'next',
          builder: (_, __) => const Scaffold(body: Text('Next')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    await tester.pumpAndSettle();

    final error = CustomError.unknown(
      message: 'Something went wrong',
      userMessage: 'ユーザー向けのエラーメッセージ',
    );

    final BuildContext context = tester.element(find.text('Home'));

    errorDialog(
      context,
      'エラーが発生しました',
      error,
      'next',
    );

    await tester.pumpAndSettle();

    expect(find.text('エラーが発生しました'), findsOneWidget);
    expect(find.text('ユーザー向けのエラーメッセージ'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Next'), findsOneWidget);
  });
}
