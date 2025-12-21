import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

Widget PrimaryButton({required String label, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),

        /// OUTER SHADOW = elevation effect
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
              color: const Color.fromRGBO(255, 255, 255, .1),

              /// INNER BORDER + GLOW
              borderRadius: BorderRadius.circular(24),
              border: const GradientBoxBorder(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF888888), // top-left color
                    Colors.transparent,
                    Color(0xFF888888), // bottom-right color
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.25, 0.75, 1.0], // control gradient stops
                ),
                width: 1,
              ),
              boxShadow: [
                /// INNER SHADOW (fake)
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            alignment: Alignment.center,
            child: Text(
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
  );
}
