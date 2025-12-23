import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:parlai/view/settings/account_informations_screen.dart';
import 'package:parlai/view/settings/logout_modal.dart';
import 'package:parlai/view/settings/privacy_policy_scree.dart';
import 'package:parlai/wdiget/glass_back_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [GlassBackButton()]),
              ),
              const SizedBox(height: 40),
              // Profile Section
              Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[700]!,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[700]!,
                            width: 2,
                          ),
                          color: Colors.grey[900],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Jenny Smith',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'jenny@gmail.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // Settings Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GlassmorphicCard(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AccountInformationScreen(),
                        ),
                      ),
                      icon: Icons.manage_accounts_outlined,
                      title: 'Account Information',
                    ),
                    const SizedBox(height: 16),
                    GlassmorphicCard(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrivacyPolicyScreen(),
                        ),
                      ),
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy & Policy',
                    ),
                    const SizedBox(height: 16),
                    GlassmorphicCard(
                      onTap: () => showLogoutModal(context),
                      icon: Icons.logout,
                      title: 'Logout',
                      isLogout: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassmorphicCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final bool isLogout;

  const GlassmorphicCard({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
    this.isLogout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        // এটা দিয়ে card auto height নিবে → সব card show হবে
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent, // Very light glass tint
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  // Inner inset shadow (content ডুবে থাকবে)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 20,
                    spreadRadius: -10,
                    offset: const Offset(0, 10),
                  ),
                  // Top highlight (border উপরে/raised মনে হবে)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, -6),
                  ),
                  // Bottom outer shadow for depth
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 28),
                      const SizedBox(width: 16),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.6),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white.withOpacity(0.7),
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
