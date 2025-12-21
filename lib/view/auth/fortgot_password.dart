import 'package:flutter/material.dart';
import 'package:parlai/view/auth/verification.dart';
import 'package:parlai/wdiget/customInputField.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(), // ⬆ top space

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Enter your email to reset your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color(0xFFB0B0B0)),
                  ),
                  SizedBox(height: 40),
                ],
              ),

              CustomInputField(
                label: "Email",
                hintText: "write down email address",
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                label: "Send Code",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VerificationScreen(),
                    ),
                  );
                },
              ),

              const Spacer(), // ⬇ bottom space
            ],
          ),
        ),
      ),
    );
  }
}

/// Normal Input
