import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget PrimaryButton({
  required String label,
  required VoidCallback onTap,
  bool isLoading = false,
  bool isDisabled = false,
}) {
  final bool disabled = isLoading || isDisabled;

  return GestureDetector(
    onTap: disabled ? null : onTap,
    child: Opacity(
      opacity: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.all(1.2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(26, 227, 227, 227),
                borderRadius: BorderRadius.circular(24),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(59, 59, 59, 1),
                      Colors.transparent,
                      Colors.transparent,
                      Color.fromARGB(255, 49, 49, 49),
                    ],
                    stops: [0.0, 0.25, 0.75, 1.0],
                  ),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: isLoading
                  ? const SpinKitWave(color: Colors.white, size: 26)
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    ),
  );
}
