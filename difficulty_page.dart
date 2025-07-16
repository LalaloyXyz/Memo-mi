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
        'emoji': '🥚',
        'color': Colors.purple.shade200,
        'colorLight': Colors.purple.shade100,
        'colorDark': Colors.purple.shade400,
        'description': 'เหมาะสำหรับผู้เริ่มต้น',
        'stars': 1,
      },
      {
        'name': 'ปานกลาง',
        'icon': Icons.sentiment_neutral,
        'emoji': '🐣',
        'color': Colors.purple.shade200,
        'colorLight': Colors.purple.shade100,
        'colorDark': Colors.purple.shade400,
        'description': 'ความท้าทายระดับกลาง',
        'stars': 2,
      },
      {
        'name': 'ยาก',
        'icon': Icons.sentiment_very_dissatisfied,
        'emoji': '🐤',
        'color': Colors.purple.shade200,
        'colorLight': Colors.purple.shade100,
        'colorDark': Colors.purple.shade400,
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
            colors: [Color(0xFFE0BBFF), Color(0xFFBFA2DB)],
          ),
          // Add floating pastel shapes
          // (for brevity, use Positioned widgets in a Stack below)
        ),
        child: Stack(
          children: [
            // Floating pastel shapes (hearts, stars, clouds)
            Positioned(
              top: 60,
              left: 30,
              child: Opacity(
                opacity: 0.12,
                child: Icon(Icons.favorite, size: 60, color: Color(0xFFBFA2DB)),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 40,
              child: Opacity(
                opacity: 0.10,
                child: Icon(Icons.star, size: 50, color: Color(0xFFE0BBFF)),
              ),
            ),
            Positioned(
              top: 180,
              right: 60,
              child: Opacity(
                opacity: 0.10,
                child: Icon(Icons.cloud, size: 70, color: Color(0xFFD1C4E9)),
              ),
            ),
            // Main content
            SafeArea(
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
                                            Color(0xFFBFA2DB),
                                            Color(0xFFE0BBFF),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(
                                              0xFFBFA2DB,
                                            ).withOpacity(0.4),
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
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                    child: _CuteLevelCard(
                                      level: level,
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
          ],
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

class _CuteLevelCard extends StatefulWidget {
  final Map<String, dynamic> level;
  final VoidCallback onTap;
  const _CuteLevelCard({required this.level, required this.onTap});

  @override
  State<_CuteLevelCard> createState() => _CuteLevelCardState();
}

class _CuteLevelCardState extends State<_CuteLevelCard>
    with TickerProviderStateMixin {
  late AnimationController _popController;
  late Animation<double> _popAnim;
  late AnimationController _emojiController;
  late Animation<double> _emojiAnim;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.05,
      value: 1.0,
    );
    _popAnim = _popController.drive(Tween(begin: 1.0, end: 1.05));
    _emojiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _emojiAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _emojiController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _popController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.level;
    return GestureDetector(
      onTapDown: (_) => _popController.forward(),
      onTapUp: (_) {
        _popController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _popController.reverse(),
      child: ScaleTransition(
        scale: _popAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: (level['color'] as Color).withOpacity(0.25),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
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
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _emojiAnim,
                  child: Text(
                    level['emoji'] as String,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            level['name'] as String,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedStarRow(count: level['stars'] as int),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level['description'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedStarRow extends StatelessWidget {
  final int count;
  const AnimatedStarRow({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
        (i) => TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + i * 200),
          builder:
              (context, value, child) => Transform.scale(
                scale: 0.7 + value * 0.3,
                child: Opacity(opacity: value, child: child),
              ),
          child: const Icon(Icons.star, color: Colors.amber, size: 18),
        ),
      ),
    );
  }
}
