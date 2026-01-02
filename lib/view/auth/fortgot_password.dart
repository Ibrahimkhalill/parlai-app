import 'package:flutter/material.dart';
import 'package:parlai/controller/auth/auth_controller.dart';
import 'package:parlai/view/auth/resetVerification.dart';
import 'package:parlai/wdiget/customInputField.dart';
import 'package:parlai/wdiget/getErrorMessage.dart';
import 'package:parlai/wdiget/glass_back_button.dart';
import 'package:parlai/wdiget/primaryButton.dart';
// apiClient instance

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  // ✅ Forget password function
  Future<void> sendResetCode() async {
    final email = emailController.text.trim();

    setState(() => _isLoading = true);

    try {
      final response = await authController.forgotPassword(email);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetVerificationScreen(userId: response['user_id']),
        ),
      );
    } catch (e) {
      // Handle DioException and show message
      final errorMessage = getErrorMessage(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft, child: GlassBackButton()),
              const Spacer(),

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

              // Email Input
              CustomInputField(
                label: "Email",
                hintText: "write down email address",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),

              // Send Code Button
              PrimaryButton(
                label: _isLoading ? "Sending..." : "Send Code",
                onTap: sendResetCode,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
