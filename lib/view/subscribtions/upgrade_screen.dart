import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parlai/view/subscribtions/payment_scuccess.dart';
import 'package:parlai/wdiget/primaryButton.dart'; // তোমার custom button

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Upgrade', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black87, Colors.black],
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Top icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "From this point on, you\nbet with confidence",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Upgrade to connect more",
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),

                    const SizedBox(height: 48),

                    // Plans column (vertical layout)
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch, // Full width
                      children: [
                        _buildPlanCard(isPremium: false),
                        const SizedBox(height: 16), // Space between plans
                        _buildPlanCard(isPremium: true),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Upgrade button
                    PrimaryButton(
                      label: 'Upgrade',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaymentSuccessScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32), // Bottom safe space
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({required bool isPremium}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 300,
          ), // Minimum height to fit content
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPremium
                  ? Colors.greenAccent.withOpacity(0.6)
                  : Colors.white.withOpacity(0.2),
              width: isPremium ? 1.5 : 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(isPremium ? 0.15 : 0.08),
                Colors.white.withOpacity(isPremium ? 0.05 : 0.02),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Text(
                    isPremium ? "Premium" : "Basic",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                isPremium ? "\$50/Yearly" : "\$10/month",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (isPremium) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: const Text(
                    "Most Popular • Save 58%",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _buildFeature("odio vitae vel eget venenatis odio ex gravida"),
              _buildFeature("faucibus massa in felis, lorem, dui elit"),
              _buildFeature("Nullam dui massa in felis, lorem, dui elit"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, color: Colors.greenAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[300]),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
