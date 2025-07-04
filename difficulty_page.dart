import 'package:flutter/material.dart';
import 'word_item.dart';
import 'scramble_game_page.dart';
import 'fill_in_game_page.dart';
import 'match_game_page.dart';
import 'time_attack_game_page.dart';

class DifficultyPage extends StatelessWidget {
  final String mode;
  final Function(String, int) onStatUpdate;
  const DifficultyPage({
    super.key,
    required this.mode,
    required this.onStatUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final levels = ['ง่าย', 'ปานกลาง', 'ยาก'];
    return Scaffold(
      appBar: AppBar(title: Text('เลือกความยาก - $mode')),
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
                        Text(
                          'เลือกความยาก',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...levels.map(
                          (level) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
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
                                child: Text(level),
                                onPressed: () {
                                  List<WordItem> words;
                                  if (level == 'ง่าย')
                                    words = easyWords;
                                  else if (level == 'ปานกลาง')
                                    words = mediumWords;
                                  else
                                    words = hardWords;

                                  Widget screen;
                                  void goBackWithScore(int score) {
                                    onStatUpdate(mode, score);
                                    Navigator.popUntil(context, (r) => r.isFirst);
                                  }

                                  switch (mode) {
                                    case 'สลับคำ':
                                      screen = ScrambleGamePage(
                                        wordList: words,
                                        onFinish: goBackWithScore,
                                      );
                                      break;
                                    case 'เติมคำ':
                                      screen = FillInGamePage(
                                        wordList: words,
                                        onFinish: goBackWithScore,
                                      );
                                      break;
                                    case 'จับคู่':
                                      screen = MatchGamePage(
                                        wordList: words,
                                        onFinish: goBackWithScore,
                                      );
                                      break;
                                    case 'แข่งกับเวลา':
                                      screen = TimeAttackGamePage(
                                        wordList: words,
                                        onFinish: goBackWithScore,
                                      );
                                      break;
                                    default:
                                      screen = const Scaffold(
                                        body: Center(child: Text('ไม่พบโหมด')),
                                      );
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => screen),
                                  );
                                },
                              ),
                            ),
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
    );
  }
} 