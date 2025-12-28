import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/config/router/route_names.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';
import 'package:rag_faq_document/pages/auth/auth_form_fields.dart';
import 'package:rag_faq_document/pages/auth/signup/signup_provider.dart';
import 'package:rag_faq_document/utils/error_dialog.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    print('✅ フォーム通過');

    await ref
        .read(signupProvider.notifier)
        .signup(
          username: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(signupProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          // 成功時にフォームをクリア
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          setState(() {
            _agreeToTerms = false;
          });

          // 必要ならログイン画面に遷移
          GoRouter.of(context).goNamed(RouteNames.signin);
        },
        error:
            (error, stackTrace) => errorDialog(
              context,
              "ユーザー作成に失敗しました。",
              error as CustomError,
              null,
            ),
      );
    });

    final signupState = ref.watch(signupProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //appBar: AppBar(title: Text('アカウント作成')),
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
                        // ユーザー名入力
                        NameFormField(nameController: _nameController),

                        SizedBox(height: 16),

                        EmailFormField(emailController: _emailController),

                        SizedBox(height: 16),

                        // パスワード入力
                        PasswordFormField(
                          passwordController: _passwordController,
                          labelText: "パスワード",
                        ),

                        SizedBox(height: 16),

                        // パスワード確認入力
                        ConfirmPasswordField(
                          passwordController: _passwordController,
                          labelText: 'パスワード（確認）',
                        ),

                        SizedBox(height: 16),

                        // 利用規約に同意
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: Color(0xFF5C7CFA),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(text: '利用規約'),
                                    TextSpan(
                                      text: ' および ',
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                    TextSpan(text: 'プライバシーポリシー'),
                                    TextSpan(
                                      text: ' に同意します',
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // アカウント作成ボタン
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                (!_agreeToTerms)
                                    ? null
                                    : signupState.maybeWhen(
                                      loading: () => null,
                                      orElse: () => _signUp,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(12, 164, 167, 1),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),

                              disabledBackgroundColor: Color.fromRGBO(12, 164, 167, 1).withValues(alpha: 0.5),
                            ),
                            child: Text(
                              style: TextStyle(fontSize: 16),
                              signupState.maybeWhen(
                                loading: () => "通信中...",
                                orElse: () => 'アカウント作成',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // ログイン画面へのリンク
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('すでにアカウントをお持ちの方は'),
                            TextButton(
                              onPressed: signupState.maybeWhen(
                                loading: () => null,
                                orElse:
                                    () =>
                                        () => GoRouter.of(
                                          context,
                                        ).goNamed(RouteNames.signin),
                              ),
                              child: Text(
                                'ログイン',
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
