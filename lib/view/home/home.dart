import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:parlai/view/subscribtions/upgrade_screen.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Logo
              Image.asset('assets/images/logo.png', width: 80, height: 80),

              const SizedBox(height: 40),

              /// Title
              const Text(
                'Discover Your ParlAi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'Performance Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              /// Description
              const Text(
                'Upload your slip to receive a confidence grade for each Pick, plus deeper statistical insights for every player prop.',
                style: TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF2A2A2A),
                      width: 2,
                    ),
                  ),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      dashPattern: const [10, 6],
                      strokeWidth: 2,
                      color: Color.fromRGBO(63, 63, 70, 1),
                      padding: const EdgeInsets.all(6),
                      radius: Radius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Upload Parlay Screenshot',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'or paste bet slip',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// Upload Button
              PrimaryButton(
                label: 'Upload',
                onTap: () {
                  if (_selectedImage != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UpgradeScreen()),
                    );
                  } else {
                    _pickImage();
                  }
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
