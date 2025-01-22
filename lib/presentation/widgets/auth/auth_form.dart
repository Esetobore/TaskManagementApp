import 'package:dufil/config/constants/app_constants.dart';
import 'package:dufil/config/routes/app_routes.dart';
import 'package:dufil/config/utils/validators.dart';
import 'package:dufil/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;

  const AuthForm({
    super.key,
    required this.isLogin,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              label: Text("Enter email address"),
              hintText: widget.isLogin ? 'Your email address' : 'johndoe@gmail.com',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              errorText: _emailError,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: widget.isLogin ? null : Validators.validateEmail,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              label: Text('Enter Password'),
              hintText: widget.isLogin ? 'Your Password' : 'min. of 8 characters',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              errorText: _passwordError,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            obscureText: _obscurePassword,
            validator: widget.isLogin ? null : Validators.validatePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: (_emailError == null && _passwordError == null) ? kPrimaryAppColor : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Continue'),
            ),
          ),
          const SizedBox(height: 24),
          if (widget.isLogin) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.signup);
              },
              child: const Text(
                'Yet to create an account? Signup here!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
          if (!widget.isLogin) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.login);
              },
              child: const Text(
                'Have an account? Login here!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _emailError = Validators.validateEmail(_emailController.text);
        _passwordError = Validators.validatePassword(_passwordController.text);
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (widget.isLogin) {
        await authProvider.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await authProvider.signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }

      if (mounted) await Navigator.of(context).pushReplacementNamed(AppRoutes.mainNavRoute);
    } catch (e) {
      setState(() {
        if (e.toString().contains('email')) {
          _emailError = e.toString();
        } else if (e.toString().contains('password')) {
          _passwordError = e.toString();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
