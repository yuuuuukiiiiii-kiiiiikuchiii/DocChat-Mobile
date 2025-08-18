import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/pages/widgets/form_fields.dart';

void main() {
  group('Form Field Validators', () {

    testWidgets('ConfirmPasswordField toggles password visibility', (tester) async {
  final controller = TextEditingController();

  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: ConfirmPasswordField(
        passwordController: controller,
        labelText: '確認用パスワード',
      ),
    ),
  ));

  expect(find.byIcon(Icons.visibility_off), findsOneWidget);

  await tester.tap(find.byIcon(Icons.visibility_off));
  await tester.pump();

  expect(find.byIcon(Icons.visibility), findsOneWidget);
});

    testWidgets('PasswordFormField toggles password visibility', (
      tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordFormField(
              passwordController: controller,
              labelText: 'パスワード',
            ),
          ),
        ),
      );

      // 初期状態では visibility_off がある
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // アイコンをタップして表示状態を変更
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // 表示アイコンが visibility に切り替わる
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('EmailFormField shows error for invalid email', (tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: EmailFormField(emailController: controller),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'invalidemail');
      formKey.currentState!.validate(); // これで validator が発動！
      await tester.pump();

      expect(find.text('有効なメールアドレスを入力してください'), findsOneWidget);
    });

    testWidgets('PasswordFormField shows error for short password', (
      tester,
    ) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: PasswordFormField(
                passwordController: controller,
                labelText: 'パスワード',
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '123');
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('パスワードは6文字以上である必要があります'), findsOneWidget);
    });

    testWidgets(
      'ConfirmPasswordField shows error when passwords do not match',
      (tester) async {
        final passwordController = TextEditingController(text: 'password123');
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: ConfirmPasswordField(
                  passwordController: passwordController,
                  labelText: '確認用パスワード',
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'different');
        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('パスワードが一致しません'), findsOneWidget);
      },
    );

    testWidgets('NameFormField shows error for too short name', (tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: NameFormField(nameController: controller),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'あ');
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text("2文字以上12文字未満で入力してください"), findsOneWidget);
    });
  });
}
