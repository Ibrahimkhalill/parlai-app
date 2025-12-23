import 'package:flutter/material.dart';
import 'package:parlai/navigation/main_tabs.dart';
import 'package:parlai/view/home/home.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Success Icon (Teal star with white check)
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00D4B2), // Teal color matching your screenshot
              ),
              child: const Icon(Icons.check, size: 70, color: Colors.white),
            ),

            const SizedBox(height: 40),

            // Main text
            const Text(
              "Your payment has been\nsuccessfully done",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.4,
              ),
            ),

            const Spacer(),

            // Bottom "Home" button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: PrimaryButton(
                  label: 'Home',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MainTabs()),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20), // Extra bottom padding
          ],
        ),
      ),
    );
  }
}
