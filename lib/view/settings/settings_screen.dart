import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parlai/controller/auth/auth_controller.dart';
import 'package:parlai/view/settings/account_informations_screen.dart';
import 'package:parlai/view/settings/logout_modal.dart';
import 'package:parlai/view/settings/privacy_policy_scree.dart';
import 'package:parlai/wdiget/glass_back_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _displayName = '';
  String _displayEmail = '';
  String? _profilePictureUrl;
  bool _isLoading = true;
  File? _newProfileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    print('Fetching profile...');
    setState(() => _isLoading = true);
    try {
      final user = await authController.getProfile();
      print(user);
      setState(() {
        _displayName = user['profile']?['name'] ?? '';
        _displayEmail = user['email_address'] ?? '';
        _profilePictureUrl = user['profile']?['profile_picture'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickProfileImage() async {
    print('Picking profile image...');
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });

      // Upload to backend
      try {
        await authController.updateProfilePicture(file: _newProfileImage);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated')),
        );
        // Refresh profile
        await _fetchProfile();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Profile Section
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GestureDetector(
                              onTap: _pickProfileImage,
                              child: Container(
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
                                  child: _newProfileImage != null
                                      ? Image.file(
                                          _newProfileImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : (_profilePictureUrl != null
                                            ? Image.network(
                                                _profilePictureUrl!,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    },
                                              )
                                            : Container(
                                                color: Colors.grey[800],
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 80,
                                                  color: Colors.grey,
                                                ),
                                              )),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _pickProfileImage,
                              child: Container(
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
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _displayName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _displayEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
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
                                builder: (_) =>
                                    const AccountInformationScreen(),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 20,
                    spreadRadius: -10,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, -6),
                  ),
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
