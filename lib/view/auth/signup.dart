import 'package:flutter/material.dart';
import 'package:parlai/controller/auth/auth_controller.dart';
import 'package:parlai/view/auth/login.dart';
import 'package:parlai/view/auth/verification.dart';
import 'package:parlai/wdiget/customInputField.dart';
import 'package:parlai/wdiget/getErrorMessage.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode:
                  AutovalidateMode.onUserInteraction, // 🔹 Real-time validation
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Image.asset('assets/images/logo.png', width: 80, height: 80),
                  const SizedBox(height: 40),
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create an Account',
                    style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
                  ),
                  const SizedBox(height: 50),

                  // Name Field
                  CustomInputField(
                    label: 'Name',
                    hintText: 'ex: Ibrahim',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Email Field
                  CustomInputField(
                    label: 'Email',
                    hintText: 'example@company.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Password Field
                  CustomInputField(
                    label: 'Password',
                    hintText: '••••••••••••••',
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Rewrite Password Field
                  CustomInputField(
                    label: 'Rewrite Password',
                    hintText: '••••••••••••••',
                    controller: _rePasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please retype your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  PrimaryButton(
                    label: _isLoading ? "Signing Up..." : "Sign Up",
                    onTap: _handleSignUp,
                  ),

                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------
  // Signup Function
  // -----------------------
  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      // ❌ Fields are invalid
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Call signup API
      int userId = await authController.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent! Check your email.")),
      );

      // Navigate to OTP Verification Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VerificationScreen(userId: userId)),
      );
    } catch (e) {
      var errorMessage = getErrorMessage(e);
      print(errorMessage);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }
}
