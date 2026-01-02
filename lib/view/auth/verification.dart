import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:parlai/controller/auth/auth_controller.dart';
import 'package:parlai/navigation/main_tabs.dart';
import 'package:parlai/wdiget/getErrorMessage.dart';
import 'package:parlai/wdiget/glass_back_button.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class VerificationScreen extends StatefulWidget {
  final int userId;
  const VerificationScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final int otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isPasting = false; // add this in your State class

  int _secondsRemaining = 41;
  Timer? _timer;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(otpLength, (index) => TextEditingController());
    _focusNodes = List.generate(otpLength, (index) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 41;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
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
      // Call verification API
      await authController.verifyOtp(
        userId: widget.userId, // optional email if required
        code: _enteredOtp,
      );
      // Navigate to Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainTabs()),
        (route) => false,
      );
    } catch (e) {
      setState(() => _errorMessage = getErrorMessage(e));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await authController.resendVerificationCode(userId: widget.userId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP resent successfully")));
      _startTimer();
    } catch (e) {
      setState(() => _errorMessage = getErrorMessage(e));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft, child: GlassBackButton()),
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

              // OTP Fields
              // OTP Field inside Row
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
                        color: const Color(0xFF2A2A2A),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (_isPasting)
                          return; // skip if we're handling a paste

                        if (value.isEmpty) {
                          if (index > 0) _focusNodes[index - 1].requestFocus();
                          return;
                        }

                        // Handle paste
                        if (value.length > 1) {
                          _isPasting = true; // start paste mode
                          final digits = value
                              .split('')
                              .take(otpLength)
                              .toList();
                          setState(() {
                            for (int i = 0; i < otpLength; i++) {
                              _controllers[i].text = i < digits.length
                                  ? digits[i]
                                  : '';
                            }
                          });
                          // focus on next empty field or last
                          if (digits.length < otpLength) {
                            _focusNodes[digits.length].requestFocus();
                          } else {
                            _focusNodes[otpLength - 1].requestFocus();
                          }
                          Future.delayed(const Duration(milliseconds: 50), () {
                            _isPasting = false; // end paste mode
                          });
                          return;
                        }

                        // Move focus forward
                        if (index < otpLength - 1) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
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
                          ? 'Resend in 00:${_secondsRemaining.toString().padLeft(2, '0')}'
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
      ),
    );
  }
}
