import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class ConfirmPasswordField extends StatefulWidget {
  const ConfirmPasswordField({
    super.key,
    required TextEditingController passwordController,
    required this.labelText,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;
  final String labelText;

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        //fillColor: Colors.white,
        labelText: widget.labelText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'パスワードを再入力してください';
        }
        if (value != widget._passwordController.text) {
          return 'パスワードが一致しません';
        }
        return null;
      },
    );
  }
}

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required TextEditingController passwordController,
    required this.labelText,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;
  final String labelText;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordController,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        //fillColor: Colors.white,
        labelText: widget.labelText,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'パスワードを入力してください';
        }
        if (value.trim().length < 6) {
          return 'パスワードは6文字以上である必要があります';
        }
        return null;
      },
    );
  }
}

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        //fillColor: Colors.white,
        prefixIcon: Icon(Icons.email),
        labelText: 'メールアドレス',
        hintText: "your@email.com",
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'メールアドレスを入力してください';
        }
        if (!isEmail(value.trim())) {
          return '有効なメールアドレスを入力してください';
        }
        return null;
      },
    );
  }
}

class NameFormField extends StatelessWidget {
  const NameFormField({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        //fillColor: Colors.white,
        labelText: 'ユーザー名',
        prefixIcon: Icon(Icons.person),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'ユーザー名を入力してください';
        }
        if (value.trim().length < 2 || value.trim().length > 12) {
          return "2文字以上12文字未満で入力してください";
        }
        return null;
      },
    );
  }
}
