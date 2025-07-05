import 'package:flutter/material.dart';
import 'word_item.dart';
import 'scramble_game_page.dart';
import 'fill_in_game_page.dart';
import 'match_game_page.dart';
import 'time_attack_game_page.dart';
import 'game_results_page.dart';

class DifficultyPage extends StatefulWidget {
  final String mode;
  final Function(String, int) onStatUpdate;
  const DifficultyPage({
    super.key,
    required this.mode,
    required this.onStatUpdate,
  });

  @override
  State<DifficultyPage> createState() => _DifficultyPageState();
}

class _DifficultyPageState extends State<DifficultyPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levels = [
      {
        'name': 'ง่าย',
        'icon': Icons.sentiment_satisfied_alt,
        'color': Colors.green,
        'colorLight': Colors.green.shade400,
        'colorDark': Colors.green.shade600,
        'description': 'เหมาะสำหรับผู้เริ่มต้น',
        'stars': 1,
      },
      {
        'name': 'ปานกลาง',
        'icon': Icons.sentiment_neutral,
        'color': Colors.orange,
        'colorLight': Colors.orange.shade400,
        'colorDark': Colors.orange.shade600,
        'description': 'ความท้าทายระดับกลาง',
        'stars': 2,
      },
      {
        'name': 'ยาก',
        'icon': Icons.sentiment_very_dissatisfied,
        'color': Colors.red,
        'colorLight': Colors.red.shade400,
        'colorDark': Colors.red.shade600,
        'description': 'สำหรับผู้เชี่ยวชาญ',
        'stars': 3,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกความยาก - ${widget.mode}'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        // Header section
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 800),
                          builder:
                              (context, value, child) => Transform.scale(
                                scale: 0.8 + (value * 0.2),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.shade400,
                                        Colors.orange.shade600,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          _getModeIcon(widget.mode),
                                          color: Colors.white,
                                          size: 48,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        widget.mode,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'เลือกระดับความยาก',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 32),

                        // Difficulty levels
                        Expanded(
                          child: ListView.builder(
                            itemCount: levels.length,
                            itemBuilder: (context, index) {
                              final level = levels[index];
                              return TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: Duration(
                                  milliseconds: 600 + (index * 200),
                                ),
                                builder:
                                    (context, value, child) => Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset((1 - value) * 50, 0),
                                        child: Transform.scale(
                                          scale: 0.9 + (value * 0.1),
                                          child: child,
                                        ),
                                      ),
                                    ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (level['color'] as MaterialColor)
                                            .withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          List<WordItem> words;
                                          if (level['name'] == 'ง่าย')
                                            words = easyWords;
                                          else if (level['name'] == 'ปานกลาง')
                                            words = mediumWords;
                                          else
                                            words = hardWords;

                                          void goBackWithScore(
                                            int score,
                                            List<GameResult> results,
                                          ) {
                                            widget.onStatUpdate(
                                              widget.mode,
                                              score,
                                            );
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => GameResultsPage(
                                                      gameMode: widget.mode,
                                                      score: score,
                                                      totalQuestions: 10,
                                                      results: results,
                                                      onGoHome: () {
                                                        Navigator.popUntil(
                                                          context,
                                                          (r) => r.isFirst,
                                                        );
                                                      },
                                                    ),
                                              ),
                                            );
                                          }

                                          Widget screen;
                                          switch (widget.mode) {
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
                                                body: Center(
                                                  child: Text('ไม่พบโหมด'),
                                                ),
                                              );
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => screen,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                level['colorLight'] as Color,
                                                level['colorDark'] as Color,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    level['icon'] as IconData,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            level['name']
                                                                as String,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          ...List.generate(
                                                            level['stars']
                                                                as int,
                                                            (
                                                              index,
                                                            ) => const Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        level['description']
                                                            as String,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.play_arrow_rounded,
                                                    color: Colors.white,
                                                    size: 24,
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
                            },
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

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'สลับคำ':
        return Icons.shuffle_rounded;
      case 'เติมคำ':
        return Icons.edit_note_rounded;
      case 'จับคู่':
        return Icons.link_rounded;
      case 'แข่งกับเวลา':
        return Icons.timer_rounded;
      default:
        return Icons.games_rounded;
    }
  }
}
