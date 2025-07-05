import 'package:flutter/material.dart';
import 'word_item.dart';

class MatchGamePage extends StatefulWidget {
  final List<WordItem> wordList;
  final Function(int) onFinish;
  const MatchGamePage({
    super.key,
    required this.wordList,
    required this.onFinish,
  });

  @override
  State<MatchGamePage> createState() => _MatchGamePageState();
}

class _MatchGamePageState extends State<MatchGamePage> {
  late List<WordItem> questions;
  late List<WordItem> currentPairs;
  late List<String> items; // ทั้งคำและความหมาย
  List<bool> matched = [];
  int? selectedIndex;
  int score = 0;
  int round = 1;

  @override
  void initState() {
    super.initState();
    questions = [...widget.wordList]..shuffle();
    _setupRound();
  }

  void _setupRound() {
    if (round > 10 || questions.length < 5) {
      widget.onFinish(score);
      return;
    }

    currentPairs = questions.sublist(0, 5);
    questions.removeRange(0, 5);

    final words = currentPairs.map((e) => e.word).toList();
    final meanings = currentPairs.map((e) => e.meaning).toList();

    words.shuffle();
    meanings.shuffle();

    items = [...words, ...meanings];
    items.shuffle();
    matched = List<bool>.filled(items.length, false);
    selectedIndex = null;
    setState(() {});
  }

  void _onTap(int i) {
    if (matched[i]) return;
    if (selectedIndex == null) {
      selectedIndex = i;
      setState(() {});
    } else {
      final a = items[selectedIndex!];
      final b = items[i];
      final isMatch = currentPairs.any(
        (w) =>
            (w.word == a && w.meaning == b) || (w.word == b && w.meaning == a),
      );
      if (isMatch) {
        matched[selectedIndex!] = true;
        matched[i] = true;
        score++;
      }
      selectedIndex = null;
      setState(() {});
      if (matched.every((m) => m)) {
        round++;
        Future.delayed(const Duration(milliseconds: 600), _setupRound);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จับคู่ รอบ $round/10'),
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
            child: Card(
              elevation: 12,
              shadowColor: Colors.deepOrange.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (_, i) {
                    final isSelected = selectedIndex == i;
                    final isDone = matched[i];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: Colors.deepOrange.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: isDone
                            ? Colors.green
                            : isSelected
                                ? Colors.orange
                                : Colors.deepOrange[400],
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: isDone ? null : () => _onTap(i),
                      child: Text(items[i], textAlign: TextAlign.center),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 