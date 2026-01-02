import 'package:flutter/material.dart';
import 'package:parlai/wdiget/apiClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parlai/navigation/main_tabs.dart';
import 'package:parlai/view/splash/landing.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  /// Determine which screen to show initially
  Future<Widget> _determineInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString('access_token');
    final int nowMs = DateTime.now().millisecondsSinceEpoch; // 13 digit
    final int? tokenValidTillSec = prefs.getInt(
      'access_token_valid_till',
    ); // 10 digit
    final int tokenValidTillMs = tokenValidTillSec != null
        ? tokenValidTillSec * 1000
        : 0;
    print("token: $token");
    print("tokenValidTill: $tokenValidTillSec");

    if (token != null && tokenValidTillSec != null) {
      print("nowMs: $nowMs, tokenValidTills: $tokenValidTillMs");

      if (nowMs < tokenValidTillMs) {
        // Token still valid → sync to ApiClient
        await apiClient.setToken(token);
        return const MainTabs();
      } else {
        // Expired → clear session
        await apiClient.clearSession();
        return const SplashScreen();

        // await clearSession();
      }
    }

    // No token / expired → go to SplashScreen
    return const SplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!;
        } else {
          // Loading indicator while determining
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
      },
    );
  }
}
