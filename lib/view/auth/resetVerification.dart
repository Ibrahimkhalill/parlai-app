import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:parlai/controller/auth/auth_controller.dart';
import 'package:parlai/view/auth/reset_password.dart';
import 'package:parlai/wdiget/getErrorMessage.dart';
import 'package:parlai/wdiget/glass_back_button.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class ResetVerificationScreen extends StatefulWidget {
  final int userId;
  const ResetVerificationScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  State<ResetVerificationScreen> createState() =>
      _ResetVerificationScreenState();
}

class _ResetVerificationScreenState extends State<ResetVerificationScreen> {
  final int otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  int _secondsRemaining = 120;
  Timer? _timer;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(otpLength, (index) => TextEditingController());
    _focusNodes = List.generate(otpLength, (index) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length < otpLength) {
      setState(() => _errorMessage = "Please enter complete OTP");
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final response = await authController.verifyResetCode(
        userId: widget.userId,
        code: _enteredOtp,
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            userId: widget.userId,
            secret_key: response['secret_key'],
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() => _errorMessage = getErrorMessage(e));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending || _secondsRemaining > 0) return;

    setState(() => _isResending = true);

    try {
      await authController.resendVerificationCode(userId: widget.userId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP resent successfully")));

      _startTimer();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = getErrorMessage(e));
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  bool get _isOtpComplete =>
      _controllers.every((controller) => controller.text.length == 1);

  String get _timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: GlassBackButton(),
                  ),
                  const Spacer(),
                  const Text(
                    'Check your email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please enter the verification code sent to your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 14),
                  ),
                  const SizedBox(height: 40),

                  // OTP Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(otpLength, (index) {
                      return Container(
                        width: 55,
                        height: 60,
                        margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _focusNodes[index].hasFocus
                                ? Colors.white
                                : const Color(0xFF2A2A2A),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              // Handle paste - distribute across fields
                              if (value.length > 1) {
                                String digits = value.replaceAll(
                                  RegExp(r'\D'),
                                  '',
                                );

                                // Clear all fields first
                                for (int i = 0; i < otpLength; i++) {
                                  _controllers[i].clear();
                                }

                                // Distribute digits starting from index 0
                                for (
                                  int i = 0;
                                  i < otpLength && i < digits.length;
                                  i++
                                ) {
                                  _controllers[i].text = digits[i];
                                }

                                // Unfocus all first
                                for (var node in _focusNodes) {
                                  node.unfocus();
                                }

                                // Determine where to focus
                                if (digits.length >= otpLength) {
                                  FocusScope.of(context).unfocus();
                                  _verifyOtp();
                                } else if (digits.length > 0 &&
                                    digits.length < otpLength) {
                                  _focusNodes[digits.length].requestFocus();
                                }
                                return;
                              }

                              // Single character input
                              value = value.replaceAll(RegExp(r'\D'), '');

                              // Limit to 1 character
                              if (value.length > 1) {
                                _controllers[index].text = value[0];
                                value = value[0];
                              }

                              if (value.isEmpty && index > 0) {
                                _controllers[index].clear();
                                _focusNodes[index - 1].requestFocus();
                              } else if (value.length == 1 &&
                                  index < otpLength - 1) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.length == 1 &&
                                  index == otpLength - 1) {
                                FocusScope.of(context).unfocus();
                              }

                              if (_isOtpComplete) {
                                FocusScope.of(context).unfocus();
                                _verifyOtp();
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),

                  const SizedBox(height: 40),
                  PrimaryButton(
                    label: _isLoading ? "Verifying..." : "Verify",
                    onTap: _verifyOtp,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't get the email? ",
                        style: TextStyle(color: Color(0xFF8E8E8E)),
                      ),
                      GestureDetector(
                        onTap: _secondsRemaining == 0 ? _resendOtp : null,
                        child: Text(
                          _secondsRemaining > 0
                              ? 'Resend in $_timerText'
                              : 'Resend',
                          style: TextStyle(
                            color: _secondsRemaining > 0
                                ? const Color(0xFF8E8E8E)
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Overlay Loading for Resend
            if (_isResending)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Sending new OTP...",
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
