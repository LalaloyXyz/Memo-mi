import 'package:flutter/material.dart';
import 'word_item.dart';
import 'game_results_page.dart';

class ScrambleGamePage extends StatefulWidget {
  final List<WordItem> wordList;
  final Function(int, List<GameResult>) onFinish;
  const ScrambleGamePage({
    super.key,
    required this.wordList,
    required this.onFinish,
  });

  @override
  State<ScrambleGamePage> createState() => _ScrambleGamePageState();
}

class _ScrambleGamePageState extends State<ScrambleGamePage> {
  late List<WordItem> questions;
  late WordItem current;
  late List<String> scrambled;
  List<int> selectedIndexes = [];
  int round = 1;
  int score = 0;
  List<GameResult> results = [];

  @override
  void initState() {
    super.initState();
    questions = [...widget.wordList]..shuffle();
    _nextRound();
  }

  void _nextRound() {
    if (round > 10 || questions.isEmpty) {
      widget.onFinish(score, results);
      return;
    }
    current = questions.removeLast();
    scrambled = current.word.toUpperCase().split('')..shuffle();
    selectedIndexes.clear();
    setState(() {});
  }

  void _select(int i) {
    if (!selectedIndexes.contains(i)) {
      setState(() {
        selectedIndexes.add(i);
      });
    }
  }

  void _remove(int i) {
    setState(() {
      selectedIndexes.remove(i);
    });
  }

  void _submit() {
    final attempt = selectedIndexes.map((i) => scrambled[i]).join();
    final isCorrect = attempt == current.word.toUpperCase();
    
    results.add(GameResult(
      word: current,
      isCorrect: isCorrect,
      userAnswer: attempt,
    ));
    
    setState(() {
      if (isCorrect) {
        score++;
      } else {
        score = (score - 1).clamp(0, double.infinity).toInt();
      }
      round++;
    });
    _nextRound();
  }

  void _reset() {
    setState(() {
      selectedIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สลับคำ รอบ $round/10'),
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
                    mainAxisSize: MainAxisSize.min,
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
                      Wrap(
                        spacing: 8,
                        children:
                            selectedIndexes
                                .map(
                                  (i) => Chip(
                                    label: Text(scrambled[i]),
                                    onDeleted: () => _remove(i),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        children: List.generate(
                          scrambled.length,
                          (i) => ElevatedButton(
                            onPressed:
                                selectedIndexes.contains(i)
                                    ? null
                                    : () => _select(i),
                            style: ElevatedButton.styleFrom(
                              elevation: 8,
                              shadowColor: Colors.deepOrange.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.deepOrange[400],
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(scrambled[i]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _reset,
                            style: ElevatedButton.styleFrom(
                              elevation: 8,
                              shadowColor: Colors.deepOrange.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.deepOrange[200],
                              foregroundColor: Colors.deepOrange[900],
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('ล้าง'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: selectedIndexes.isEmpty ? null : _submit,
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
                        ],
                      ),
                    ],
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
