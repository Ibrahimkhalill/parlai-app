import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:parlai/controller/home/home_controller.dart';
import 'package:parlai/wdiget/getErrorMessage.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class HomeScreen extends StatefulWidget {
  final Function(SlipAnalysisResponse) onAnalysisComplete;

  const HomeScreen({super.key, required this.onAnalysisComplete});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _analyzeSlip() async {
    if (_selectedImage == null) {
      _pickImage();
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final result = await homeController.analyzeSlip(
        imageFile: _selectedImage!,
      );

      if (!mounted) return;

      // Navigate to results screen
      widget.onAnalysisComplete(result);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getErrorMessage(e)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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

                  /// Image Upload Area
                  GestureDetector(
                    onTap: _isAnalyzing ? null : _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 240,
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
                              ? Stack(
                                  children: [
                                    Image.file(
                                      _selectedImage!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    if (!_isAnalyzing)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedImage = null;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
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
                                        'Upload a bet slip',
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

                  /// Upload/Analyze Button
                  PrimaryButton(
                    label: _isAnalyzing
                        ? 'Analyzing...'
                        : _selectedImage != null
                        ? 'Analyze Slip'
                        : 'Upload',
                    onTap: _analyzeSlip,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            /// Loading Overlay
            if (_isAnalyzing)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Analyzing your slip...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This may take a few seconds',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
