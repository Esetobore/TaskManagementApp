import 'package:dufil/presentation/widgets/auth/auth_form.dart';
import 'package:dufil/presentation/widgets/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      title: "Todoey",
      subtitle: "Login into your account here",
      child: AuthForm(isLogin: true),
    );
  }
}
