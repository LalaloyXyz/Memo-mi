import 'package:flutter/material.dart';
import 'dart:async';
import 'word_item.dart';
import 'game_results_page.dart';

class TimeAttackGamePage extends StatefulWidget {
  final List<WordItem> wordList;
  final Function(int, List<GameResult>) onFinish;
  const TimeAttackGamePage({
    super.key,
    required this.wordList,
    required this.onFinish,
  });

  @override
  State<TimeAttackGamePage> createState() => _TimeAttackGamePageState();
}

class _TimeAttackGamePageState extends State<TimeAttackGamePage> {
  late List<WordItem> questions;
  late WordItem current;
  late List<String> letters;
  List<int> selectedIndexes = [];
  int score = 0;
  int round = 1;
  static const int maxTime = 10;
  int timeLeft = maxTime;
  Timer? timer;
  List<GameResult> results = [];

  @override
  void initState() {
    super.initState();
    questions = [...widget.wordList]..shuffle();
    _startRound();
  }

  void _startRound() {
    if (round > 10 || questions.isEmpty) {
      _endGame();
      return;
    }
    current = questions.removeLast();
    letters = current.word.toUpperCase().split('')..shuffle();
    selectedIndexes.clear();
    timeLeft = maxTime;
    _startTimer();
    setState(() {});
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft <= 0) {
        t.cancel();
        // Time ran out, add result as incorrect
        results.add(GameResult(
          word: current,
          isCorrect: false,
          userAnswer: 'หมดเวลา',
        ));
        _nextRound();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  void _onTap(int i) {
    if (!selectedIndexes.contains(i)) {
      setState(() {
        selectedIndexes.add(i);
      });
    }
  }

  void _removeLetter(int i) {
    setState(() {
      selectedIndexes.remove(i);
    });
  }

  void _submit() {
    final attempt = selectedIndexes.map((i) => letters[i]).join();
    final isCorrect = attempt == current.word.toUpperCase();
    
    results.add(GameResult(
      word: current,
      isCorrect: isCorrect,
      userAnswer: attempt,
    ));
    
    setState(() {
      if (isCorrect) {
        // Time-based scoring: 10-6 seconds = +5, 5-0 seconds = +1
        if (timeLeft >= 6) {
          score += 5;
        } else {
          score += 1;
        }
      } else {
        // Wrong answer: -1 point, minimum 0
        score = (score - 1).clamp(0, double.infinity).toInt();
      }
    });
    _nextRound();
  }

  void _nextRound() {
    timer?.cancel();
    round++;
    _startRound();
  }

  void _endGame() {
    timer?.cancel();
    widget.onFinish(score, results);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แข่งกับเวลา รอบ $round/10'),
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
                      LinearProgressIndicator(
                        value: timeLeft / maxTime,
                        backgroundColor: Colors.grey[300],
                        color: Colors.deepOrange,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'เวลาที่เหลือ: $timeLeft วินาที',
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'คำแปล: ${current.meaning}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        children: selectedIndexes
                            .map(
                              (i) => Chip(
                                label: Text(letters[i]),
                                onDeleted: () => _removeLetter(i),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        children: List.generate(
                          letters.length,
                          (i) => ElevatedButton(
                            onPressed: selectedIndexes.contains(i) ? null : () => _onTap(i),
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
                            child: Text(letters[i]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
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
