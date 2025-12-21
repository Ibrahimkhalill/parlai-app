import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlassBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final String iconPath;

  const GlassBackButton({
    super.key,
    this.onTap,
    this.size = 40,
    this.iconPath = 'assets/icons/back.svg',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(size),
            ),
            child: SvgPicture.asset(iconPath, width: size, height: size),
          ),
        ),
      ),
    );
  }
}
