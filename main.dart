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
        fontFamily: 'Ubuntu Mono sans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}
