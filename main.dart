import 'package:flutter/material.dart';
import 'auth_wrapper.dart';

void main() {
  runApp(const MemoWordsApp());
}

class MemoWordsApp extends StatelessWidget {
  const MemoWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoWords',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'UbuntuMono',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFBFA2DB)),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}
