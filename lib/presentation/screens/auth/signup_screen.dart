import 'package:dufil/presentation/widgets/auth/auth_form.dart';
import 'package:dufil/presentation/widgets/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      title: "Todoey",
      subtitle: "Signup into your account here",
      child: AuthForm(isLogin: false),
    );
  }
}
