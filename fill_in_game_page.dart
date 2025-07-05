import 'package:flutter/material.dart';
import 'word_item.dart';

class FillInGamePage extends StatefulWidget {
  final List<WordItem> wordList;
  final Function(int) onFinish;
  const FillInGamePage({
    super.key,
    required this.wordList,
    required this.onFinish,
  });

  @override
  State<FillInGamePage> createState() => _FillInGamePageState();
}

class _FillInGamePageState extends State<FillInGamePage> {
  late List<WordItem> questions;
  late WordItem current;
  late List<bool> revealed;
  int round = 1;
  int score = 0;
  final inputCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    questions = [...widget.wordList]..shuffle();
    _nextRound();
  }

  void _nextRound() {
    if (round > 10 || questions.isEmpty) {
      widget.onFinish(score);
      return;
    }
    current = questions.removeLast();
    final len = current.word.length;
    final indices = List<int>.generate(len, (i) => i)..shuffle();
    final maskCount = (len * 0.4).ceil();
    revealed = List<bool>.filled(len, true);
    for (int i = 0; i < maskCount; i++) {
      revealed[indices[i]] = false;
    }
    inputCtl.clear();
    setState(() {});
  }

  String get maskedWord {
    String result = '';
    for (int i = 0; i < current.word.length; i++) {
      result += revealed[i] ? current.word[i] : '_';
    }
    return result.toUpperCase();
  }

  void _submit() {
    if (inputCtl.text.trim().toUpperCase() == current.word.toUpperCase()) {
      score++;
    }
    round++;
    _nextRound();
  }

  @override
  void dispose() {
    inputCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เติมคำ รอบ $round/10'),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '$score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 195, 180),
              Color.fromARGB(255, 249, 192, 122),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 12,
                    shadowColor: Colors.deepOrange.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              current.emoji,
                              style: const TextStyle(fontSize: 64),
                            ),
                          ),
                          Text(
                            'คำแปล: ${current.meaning}',
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            maskedWord,
                            style: const TextStyle(fontSize: 30, letterSpacing: 4),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: inputCtl,
                            decoration: const InputDecoration(labelText: 'พิมพ์คำที่ถูกต้อง'),
                            textCapitalization: TextCapitalization.characters,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: inputCtl.text.trim().isEmpty ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                elevation: 8,
                                shadowColor: Colors.deepOrange.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Colors.deepOrange[600],
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('ยืนยัน'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
