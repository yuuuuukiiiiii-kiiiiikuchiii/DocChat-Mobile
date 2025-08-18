import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/config/router/route_names.dart';

class PasswordResetSuccess extends StatefulWidget {
  final String email;
  const PasswordResetSuccess({
    super.key,
    required this.email,
  });

  @override
  State<PasswordResetSuccess> createState() => _PasswordResetSuccessState();
}

class _PasswordResetSuccessState extends State<PasswordResetSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 16),
              Text(
                'リセットリンクを送信しました',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'メールアドレス ${widget.email} にパスワードリセットのリンクを送信しました。メールをご確認ください。',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green[800]),
              ),
              SizedBox(height: 24),
              // ログイン画面に戻るボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(RouteNames.signin);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5C7CFA),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('ログイン画面に戻る', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
