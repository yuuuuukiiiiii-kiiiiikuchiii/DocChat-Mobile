import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/core/app_state.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/profile/profile_screen_provider.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(profileScreenProvider, (prev, next) {
      next.whenOrNull(
        
        error:
            (error, stackTrace) =>
                errorDialog(context, "通信に失敗しました", error as CustomError, null),
      );
    });

    final profileState = ref.watch(profileScreenProvider);
    return Scaffold(
      body: SafeArea(
        child: profileState.when(
          data: (data) {
           
            return RefreshIndicator(
              onRefresh: () => _onRefresh(ref),
              color: Color.fromARGB(255, 42, 204, 166),
              backgroundColor: Colors.white,
              strokeWidth: 2.5,
              displacement: 40,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                    left: 16.0,
                    top: 48.0,
                  ),
                  child: Column(
                    children: [
                      // プロフィールヘッダー
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              data.userName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data.email,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '登録日: ${formatDateToJapanese(data.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // 統計情報
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '統計情報',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  context: context,
                                  icon: Icons.description,
                                  count: data.totalDocuments,
                                  label: 'ドキュメント',
                                ),
                                _buildStatItem(
                                  context: context,
                                  icon: Icons.question_answer,
                                  count: data.totalQuestions,
                                  label: '質問数',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      SizedBox(height: 24),

                      // ログアウトボタン
                      LogoutButton(ref: ref, mounted: mounted),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "データの取得に失敗しました。",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        ref.read(profileScreenProvider.notifier).reload();
                      },
                      child: const Text("再度更新", style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () {
            return Center(
              child: SpinKitFadingCircle(color: Colors.grey, size: 50.0),
            );
          },
        ),
      ),
    );
  }

  // 日付フォーマット用のユーティリティ関数
  String formatDateToJapanese(String isoDateString) {
    try {
      // ISO 8601形式の文字列をDateTimeオブジェクトに変換
      final dateTime = DateTime.parse(isoDateString);

      // 日本語形式でフォーマット
      return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
    } catch (e) {
      // パースに失敗した場合は元の文字列を返す
      print('Date parsing failed: $e');
      return isoDateString;
    }
  }

  // リフレッシュ処理
  Future<void> _onRefresh(WidgetRef ref) async {
    // プロバイダーを無効化して再取得
    ref.invalidate(profileScreenProvider);
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required int count,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Color.fromARGB(255, 42, 204, 166), size: 28),
        SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.ref, required this.mounted});

  final WidgetRef ref;
  final bool mounted;

  /// プラットフォームに応じてダイアログ表示
  Future<bool?> _confirmLogout(BuildContext context) async {
    final isCupertino = Theme.of(context).platform == TargetPlatform.iOS;

    if (isCupertino) {
      // iOS風アニメーション＆UI
      return showCupertinoDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('ログアウト'),
            content: const Text('本当にログアウトしますか？'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('キャンセル'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('ログアウト'),
                
              ),
            ],
          );
        },
      );
    } else {
      // Material
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('ログアウト'),
            content: const Text('本当にログアウトしますか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('ログアウト'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.logout),
        label: Text('ログアウト'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[400],
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          // ログアウト処理
          final goRouter = GoRouter.of(context);
          final removeOrNot = await _confirmLogout(context);
          if (removeOrNot == true) {
            await ref.read(profileScreenProvider.notifier).logout();
            if (mounted) {
              ref.read(authStatusProvider.notifier).state =
                  AuthStatus.unauthenticated;
              goRouter.goNamed(RouteNames.signin);
            }
          }
        },
      ),
    );
  }
}
