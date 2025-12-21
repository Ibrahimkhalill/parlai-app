import 'package:flutter/material.dart';
import 'package:parlai/view/auth/fortgot_password.dart'; // ForgotPasswordScreen
import 'package:parlai/view/auth/login.dart';
import 'package:parlai/wdiget/customInputField.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Logo
                Image.asset('assets/images/logo.png', width: 80, height: 80),

                const SizedBox(height: 40),

                // Title
                const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  'Create an Account',
                  style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
                ),

                const SizedBox(height: 50),
                CustomInputField(
                  label: 'Name',
                  hintText: 'ex:ibrahim',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),

                // Email Field
                CustomInputField(
                  label: 'Email',
                  hintText: 'justin45@company.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),

                // Password Field
                CustomInputField(
                  label: 'Password',
                  hintText: '••••••••••••••',
                  controller: _passwordController,
                  isPassword: true,
                ),

                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Rewrite password',
                  hintText: '••••••••••••••',
                  controller: _passwordController,
                  isPassword: true,
                ),

                // Remember Me + Forgot Password
                const SizedBox(height: 40),

                // Log In Button - Correct way
                PrimaryButton(
                  label: "Sign Up",
                  onTap: () {
                    // এখানে তোমার লগইন লজিক লিখবে (API call, validation ইত্যাদি)
                    // উদাহরণস্বরূপ সরাসরি অন্য স্ক্রিনে যাওয়ার জন্য (পরে বদলাবে)

                    // টেস্টিং এর জন্য
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logging in...")),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
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
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
