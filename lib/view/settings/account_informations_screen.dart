import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parlai/wdiget/glass_back_button.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({Key? key}) : super(key: key);

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String _displayName = 'Jenny Smith';
  String _displayEmail = 'jenny@gmail.com';
  bool _isEditingName = false;
  bool _isEditingEmail = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _displayName);
    _emailController = TextEditingController(text: _displayEmail);
    _passwordController = TextEditingController(text: '••••••••••••••••');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Row(
                  children: [
                    GlassBackButton(),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    const Text(
                      'Your name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isEditingName
                        ? _buildEditingField(
                            controller: _nameController,
                            hintText: 'Full name',
                            onSave: () {
                              setState(() {
                                _displayName = _nameController.text;
                                _isEditingName = false;
                              });
                            },
                            onCancel: () {
                              setState(() {
                                _nameController.text = _displayName;
                                _isEditingName = false;
                              });
                            },
                          )
                        : _buildDisplayField(
                            value: _displayName,
                            onEdit: () {
                              setState(() {
                                _isEditingName = true;
                              });
                            },
                            actionLabel: 'Edit',
                          ),
                    const SizedBox(height: 32),
                    // Email Field
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isEditingEmail
                        ? _buildEditingField(
                            controller: _emailController,
                            hintText: 'Email address',
                            onSave: () {
                              setState(() {
                                _displayEmail = _emailController.text;
                                _isEditingEmail = false;
                              });
                            },
                            onCancel: () {
                              setState(() {
                                _emailController.text = _displayEmail;
                                _isEditingEmail = false;
                              });
                            },
                          )
                        : _buildDisplayField(
                            value: _displayEmail,
                            onEdit: () {
                              setState(() {
                                _isEditingEmail = true;
                              });
                            },
                            actionLabel: 'Edit',
                          ),
                    const SizedBox(height: 32),
                    // Password Field
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDisplayField(
                      value: '••••••••••••••••',
                      onEdit: () {},
                      actionLabel: 'Change',
                      isPassword: true,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayField({
    required String value,
    required VoidCallback onEdit,
    required String actionLabel,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
        const SizedBox(height: 8),
        Divider(color: Colors.grey[800], thickness: 1, height: 1),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: onEdit,
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.edit,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    actionLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditingField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onSave,
    required VoidCallback onCancel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey[700]!, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey[700]!, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(
                color: Color(0xFF4CAF50),
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            // Cancel Button
            Expanded(
              child: ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: Colors.grey[800]!, width: 1),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Save Button
            Expanded(
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
