import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parlai/view/grade/grade.dart';
import 'package:parlai/view/home/home.dart';
import 'package:parlai/view/settings/settings_screen.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    GradeScreen(),
    SettingsScreen(),
  ];

  /// Gradient
  final LinearGradient grd = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(249, 251, 255, 1),
      Color.fromRGBO(129, 165, 244, 1),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// BODY (no SafeArea here)
      body: IndexedStack(index: _currentIndex, children: _pages),

      /// BOTTOM NAV (SafeArea applied here)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              /// Inner shadow
              Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(-2, -2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),

              /// Glass container
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          icon: FontAwesomeIcons.houseUser,
                          label: "Home",
                          index: 0,
                        ),
                        _buildNavItem(
                          icon: FontAwesomeIcons.barChart,
                          label: "Grade",
                          index: 1,
                        ),
                        _buildNavItem(
                          icon: FontAwesomeIcons.gear,
                          label: "Settings",
                          index: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================
  /// Bottom Nav Item
  /// ============================
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A2A2A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            /// Icon
            isSelected
                ? ShaderMask(
                    shaderCallback: (bounds) => grd.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: FaIcon(icon, size: 20, color: Colors.white),
                  )
                : FaIcon(icon, size: 20, color: Colors.white),

            const SizedBox(width: 6),

            /// Label (only selected)
            if (isSelected)
              ShaderMask(
                shaderCallback: (bounds) => grd.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
