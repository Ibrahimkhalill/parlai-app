import 'package:flutter/material.dart';
import 'package:parlai/controller/auth/auth_controller.dart';
import 'package:parlai/view/auth/login.dart';
import 'package:parlai/wdiget/customInputField.dart';
import 'package:parlai/wdiget/getErrorMessage.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.userId,
    required this.secret_key,
  });

  final int userId;
  final String secret_key;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authController.resetPassword(
        userId: widget.userId,
        password: _passwordController.text,
        secret_key: widget.secret_key,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getErrorMessage(e)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const SizedBox(height: 40),

                // Title
                const Center(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                const Center(
                  child: Text(
                    'Enter your new password here',
                    style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 48),

                // Password Field
                CustomInputField(
                  label: 'Password',
                  hintText: '••••••••••••••',
                  controller: _passwordController,
                  isPassword: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24),

                // Confirm Password Field
                CustomInputField(
                  label: 'Rewrite password',
                  hintText: '••••••••••••••',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 40),

                // Submit Button
                PrimaryButton(
                  label: _isLoading ? 'Submitting...' : 'Submit',
                  onTap: _handleSubmit,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
