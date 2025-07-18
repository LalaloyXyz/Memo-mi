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
      home: const AuthWrapper(),
    );
  }
}
