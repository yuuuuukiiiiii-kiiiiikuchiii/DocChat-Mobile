import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/pages/auth/password_reset/password_reset_screen.dart';
import 'package:rag_faq_document/pages/auth/password_reset/password_reset_success.dart';
import 'package:rag_faq_document/pages/auth/signin/signin_screen.dart';
import 'package:rag_faq_document/pages/auth/signup/signup_screen.dart';
import 'package:rag_faq_document/pages/chat/chat_screen.dart';
import 'package:rag_faq_document/pages/documents/document_gridview.dart';
import 'package:rag_faq_document/pages/home/home_screen.dart';
import 'package:rag_faq_document/pages/load/loading_screen.dart';
import 'package:rag_faq_document/pages/onboarding/onboarding_screen.dart';
import 'package:rag_faq_document/pages/profile/profile_screen.dart';
import 'package:rag_faq_document/pages/scaffold_with_nav_bar.dart';
import 'package:rag_faq_document/pages/splash/splash_screen.dart';
import 'package:rag_faq_document/pages/upload/upload_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) {
          print('##### Splash #####');
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (context, state) {
          print('##### Onboarding #####');
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: '/signin',
        name: RouteNames.signin,
        builder: (context, state) {
          print('##### SignIn #####');
          return SigninScreen();
        },
      ),
      GoRoute(
        path: '/signup',
        name: RouteNames.signup,
        builder: (context, state) {
          print('##### SignUp #####');
          return SignupScreen();
        },
      ),
      GoRoute(
        path: '/passwordReset',
        name: RouteNames.passwordReset,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          print('##### PasswordReset #####');
          return PasswordResetScreen();
        },
      ),
      GoRoute(
        path: '/passwordResetSuccess',
        name: RouteNames.passwordResetSuccess,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          print('##### PasswordResetSuccess #####');
          final extra = state.extra as Map<String, dynamic>;
          final email = extra["email"];
          return PasswordResetSuccess(email: email,);
        },
      ),

      GoRoute(
        path: '/chat',
        name: RouteNames.chat,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final documentTitle = extra["title"];
          final chatId = extra["chatId"];
          final documentId = extra["documentId"];
          print('##### Chat #####');
          return ChatScreen(
            documentTitle: documentTitle,
            documentId: documentId,
            chatId: chatId,
          );
        },
      ),
      GoRoute(
        path: '/loading',
        name: RouteNames.loading,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final documentId = extra["documentId"];
          final filePath = extra["filePath"];
          final fileType = extra["fileType"];
          print('##### Loading #####');
          return LoadingScreen(
            documentId: documentId,
            filePath: filePath,
            fileType: fileType,
          );
        },
      ),
      GoRoute(
        path: '/upload',
        name: RouteNames.upload,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          print('##### Upload #####');
          return UploadScreen();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/home",
                name: RouteNames.home,

                builder: (context, state) {
                  print('##### Home #####');
                  return const HomeScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/documents",
                name: RouteNames.documents,
                builder: (context, state) {
                  print('##### Documents #####');
                  return const DocumentGridview();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/profile",
                name: RouteNames.profile,
                builder: (context, state) {
                  print('##### Profile #####');
                  return const ProfileScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
