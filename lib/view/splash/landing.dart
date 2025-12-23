import 'package:flutter/material.dart';
import 'package:parlai/view/auth/login.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Status bar spacing
              const SizedBox(height: 8),

              Expanded(
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: PrimaryButton(
                  label: 'Next',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
