import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (_, __) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/signin',
          name: 'signin',
          builder: (_, __) => const SigninScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (_, __) => const SignupScreen(),
        ),
        GoRoute(
          path: '/upload',
          name: 'upload',
          builder: (_, __) => const UploadScreen(),
        ),
      ],
    );
  });

  Widget createApp() {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets('navigates to Splash, Onboarding, and SignIn', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    expect(find.text('Splash'), findsOneWidget);

    router.goNamed('onboarding');
    await tester.pumpAndSettle();
    expect(find.text('Onboarding'), findsOneWidget);

    router.goNamed('signin');
    await tester.pumpAndSettle();
    expect(find.text('SignIn'), findsOneWidget);
  });

  testWidgets('navigates to Signup and Upload', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    router.goNamed('signup');
    await tester.pumpAndSettle();
    expect(find.text('SignUp'), findsOneWidget);

    router.goNamed('upload');
    await tester.pumpAndSettle();
    expect(find.text('Upload'), findsOneWidget);
  });

  testWidgets('navigates to Chat and passes extra', (tester) async {
  final extraData = {
    'documentId': 'doc123',
    'chatId': 'chat456',
    'title': 'Test Document',
  };

  final router = GoRouter(
    initialLocation: '/chat',
    routes: [
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ChatScreen(
            documentId: extra['documentId'] ?? '',
            chatId: extra['chatId'] ?? '',
            documentTitle: extra['title'] ?? '',
          );
        },
      ),
    ],
  );

  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: router,
    ),
  );

  // pushNamed を使って extra をセットしてからナビゲーション
  router.pushNamed('chat', extra: extraData);
  await tester.pumpAndSettle();

  expect(find.text('Chat: chat456, doc123, Test Document'), findsOneWidget);
});


testWidgets('navigates to Loading and passes extra', (tester) async {
  final extraData = {
    'documentId': 'doc789',
    'filePath': '/path/to/file.pdf',
    'fileType': 'pdf',
  };

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return LoadingScreen(
            documentId: extra['documentId'] ?? '',
            filePath: extra['filePath'] ?? '',
            fileType: extra['fileType'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => Container(), // dummy home
      ),
    ],
  );

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));

  // extra を渡して遷移
  router.pushNamed('loading', extra: extraData);
  await tester.pumpAndSettle();

  expect(find.text('Loading: doc789, /path/to/file.pdf, pdf'), findsOneWidget);
});


testWidgets('navigates inside StatefulShellRoute', (tester) async {
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) {
          return Scaffold(
            body: navShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/documents',
                name: 'documents',
                builder: (_, __) => const DocumentScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();

  expect(find.text('Home'), findsOneWidget);

  router.go('/documents');
  await tester.pumpAndSettle();
  expect(find.text('Documents'), findsOneWidget);

  router.go('/profile');
  await tester.pumpAndSettle();
  expect(find.text('Profile'), findsOneWidget);
});


}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Home');
}

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Documents');
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Profile');
}


class ChatScreen extends StatelessWidget {
  final String documentId;
  final String chatId;
  final String documentTitle;

  const ChatScreen({
    super.key,
    required this.documentId,
    required this.chatId,
    required this.documentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Chat: $chatId, $documentId, $documentTitle');
  }
}

class LoadingScreen extends StatelessWidget {
  final String documentId;
  final String filePath;
  final String fileType;

  const LoadingScreen({
    super.key,
    required this.documentId,
    required this.filePath,
    required this.fileType,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Loading: $documentId, $filePath, $fileType');
  }
}



class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Splash');
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Onboarding');
  }
}

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('SignIn');
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('SignUp');
  }
}

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Upload');
  }
}
