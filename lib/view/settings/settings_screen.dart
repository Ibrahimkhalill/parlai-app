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
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Row(children: [GlassBackButton()]),
              ),
              const SizedBox(height: 40),
              // Profile Section
              Column(
                children: [
                  // Profile Image with Camera Icon
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
                  // Name
                  const Text(
                    'Jenny Smith',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email
                  Text(
                    'jenny@gmail.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // Settings Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Account Information
                    GlassmorphicCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AccountInformationScreen(),
                          ),
                        );
                      },
                      icon: Icons.manage_accounts_outlined,
                      title: 'Account Information',
                    ),
                    const SizedBox(height: 16),
                    // Privacy & Policy
                    GlassmorphicCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrivacyPolicyScreen(),
                          ),
                        );
                      },
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy & Policy',
                    ),
                    const SizedBox(height: 16),
                    // Logout
                    GlassmorphicCard(
                      onTap: () {
                        showLogoutModal(context); // Call this function
                      },
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.2,
              ),
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: Icon(
                        icon,
                        color: Colors.white.withOpacity(0.9),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.6),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
