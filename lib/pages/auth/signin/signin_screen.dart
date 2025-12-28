import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/core/app_state.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/auth/signin/signin_provider.dart';
import 'package:rag_faq_document/pages/widgets/form_fields.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

// ログイン画面
class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    await ref
        .read(signinProvider.notifier)
        .signin(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    // 1) まず現在の値を1フレーム後にチェックして表示（初回遷移時）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final err = ref.read(bootErrorProvider);
      if (err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err.userMessage)));
        ref.read(bootErrorProvider.notifier).state = null; // ★消費（ワンショット）
      }
    });

    // 2) その後の変化（再試行など）も拾いたいなら listen も追加（任意）
    ref.listen<CustomError?>(bootErrorProvider, (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.userMessage)));
        ref.read(bootErrorProvider.notifier).state = null; // ★消費
      }
    });
    ref.listen<AsyncValue<void>>(signinProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          ref.read(authStatusProvider.notifier).state =
              AuthStatus.authenticated;
          if (!context.mounted) return;
          GoRouter.of(context).goNamed(RouteNames.home);
        },
        error: (error, stackTrace) {
          final custom =
              error is CustomError
                  ? error
                  : CustomError.unknown(message: error.toString());

          if (custom is ServerError && custom.statusCode == 429) {
            errorDialog(context, "ログインが一時的にロックされています", custom, null);
          } else {
            errorDialog(context, "ログイン失敗しました", custom, null);
          }
        },
      );
    });

    final signinState = ref.watch(signinProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Form(
                autovalidateMode: _autovalidateMode,
                key: _formKey,
                child: ListView(
                  reverse: true,
                  shrinkWrap: true,
                  children:
                      [
                        //ロゴ
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 42, 204, 166),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.description,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 16),
                        Text(
                          textAlign: TextAlign.center,
                          'DocChat',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),

                        // メールアドレス入力
                        EmailFormField(emailController: _emailController),
                        SizedBox(height: 16),

                        // パスワード入力
                        PasswordFormField(
                          passwordController: _passwordController,
                          labelText: 'パスワード',
                        ),
                        SizedBox(height: 8),

                        // パスワードを忘れた場合のリンク
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: signinState.maybeWhen(
                              loading: () => null,
                              orElse:
                                  () =>
                                      () => GoRouter.of(
                                        context,
                                      ).goNamed(RouteNames.passwordReset),
                            ),
                            child: Text(
                              'パスワードをお忘れですか？',
                              style: TextStyle(color: Color(0xFF5C7CFA)),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // ログインボタン
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: signinState.maybeWhen(
                              loading: () => null,
                              orElse: () => _login,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(12, 164, 167, 1),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Color.fromRGBO(
                                12,
                                164,
                                167,
                                1,
                              ).withValues(alpha: 0.4),
                            ),
                            child: Text(
                              style: TextStyle(fontSize: 16),
                              signinState.maybeWhen(
                                loading: () => '通信中...',
                                orElse: () => 'ログイン',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),

                        // 新規アカウント作成セクション
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('アカウントをお持ちでない方は'),
                            TextButton(
                              onPressed: signinState.maybeWhen(
                                loading: () => null,
                                orElse:
                                    () =>
                                        () => GoRouter.of(
                                          context,
                                        ).goNamed(RouteNames.signup),
                              ),
                              child: Text(
                                '新規登録',
                                style: TextStyle(
                                  color: Color(0xFF5C7CFA),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ].reversed.toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
