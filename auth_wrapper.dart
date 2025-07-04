import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;
  String? userEmail;
  Map<String, int> stats = {
    'สลับคำ': 0,
    'เติมคำ': 0,
    'จับคู่': 0,
    'แข่งกับเวลา': 0,
  };

  void login(String email) {
    setState(() {
      isLoggedIn = true;
      userEmail = email;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
      userEmail = null;
      stats = {'สลับคำ': 0, 'เติมคำ': 0, 'จับคู่': 0, 'แข่งกับเวลา': 0};
    });
  }

  void updateStat(String mode, int score) {
    setState(() {
      stats[mode] = (stats[mode] ?? 0) + score;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return LoginPage(onLogin: login);
    }
    return HomePage(
      email: userEmail!,
      stats: stats,
      onLogout: logout,
      onStatUpdate: updateStat,
    );
  }
} 