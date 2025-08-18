import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/auth/password_reset/password_reset_provider.dart';
import 'package:rag_faq_document/pages/widgets/form_fields.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(passwordResetProvider, (prev, next) {
      next.whenOrNull(
        data: (data) {
          _emailController.clear();

          GoRouter.of(context).goNamed(
            RouteNames.passwordResetSuccess,
            extra: {"email": _emailController.text.trim()},
          );
        },
        error:
            (error, stackTrace) => errorDialog(
              context,
              "メール送信に失敗しました",
              error as CustomError,
              null,
            ),
      );
    });

    void submit() async {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });

      final form = _formKey.currentState;

      if (form == null || !form.validate()) return;

      await ref
          .read(passwordResetProvider.notifier)
          .passwordReset(_emailController.text.trim());
    }

    final passwordResetState = ref.watch(passwordResetProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_reset, size: 80, color: Color(0xFF5C7CFA)),
                  SizedBox(height: 24),
                  Text(
                    'パスワードをリセット',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'アカウントに登録されているメールアドレスを入力してください。パスワードリセットのリンクをお送りします。',
                    textAlign: TextAlign.start,
                    //style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 32),

                  Column(
                    children: [
                      // メールアドレス入力
                      EmailFormField(emailController: _emailController),

                      SizedBox(height: 24),
                      // リセットリンク送信ボタン
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: passwordResetState.maybeWhen(
                            loading: () => null,
                            orElse: () => submit,
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 42, 204, 166),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Color.fromARGB(
                              255,
                              42,
                              204,
                              166,
                            ).withValues(alpha: 0.5),
                          ),
                          child: passwordResetState.maybeWhen(
                            loading: () {
                              return SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            orElse: () {
                              return Text(
                                'リセットリンクを送信',
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      // ログイン画面へのリンク
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        child: Text(
                          'ログイン画面に戻る',
                          style: TextStyle(
                            color: Color(0xFF5C7CFA),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
