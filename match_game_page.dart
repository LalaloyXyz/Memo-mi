import 'package:flutter/material.dart';
import 'word_item.dart';
import 'game_results_page.dart';
import 'dart:async';

class MatchGamePage extends StatefulWidget {
  final List<WordItem> wordList;
  final Function(int, List<GameResult>) onFinish;
  const MatchGamePage({
    super.key,
    required this.wordList,
    required this.onFinish,
  });

  @override
  State<MatchGamePage> createState() => _MatchGamePageState();
}

class _MatchGamePageState extends State<MatchGamePage>
    with TickerProviderStateMixin {
  late List<WordItem> questions;
  late List<WordItem> currentPairs;
  late List<String> items; // ทั้งคำและความหมาย
  List<bool> matched = [];
  int? selectedIndex;
  int score = 0;
  int round = 1;
  List<GameResult> results = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // For wrong match feedback
  List<int> wrongMatchIndexes = [];
  Timer? _wrongMatchTimer;

  @override
  void initState() {
    super.initState();
    questions = [...widget.wordList]..shuffle();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _setupRound();
  }

  void _setupRound() {
    if (round > 10 || questions.length < 5) {
      widget.onFinish(score, results);
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
    wrongMatchIndexes.clear();
    _wrongMatchTimer?.cancel();
    _animationController.reset();
    _animationController.forward();
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

        // Find the correct pair for this match
        final correctPair = currentPairs.firstWhere(
          (w) =>
              (w.word == a && w.meaning == b) ||
              (w.word == b && w.meaning == a),
        );

        // Add result for correct match
        results.add(
          GameResult(
            word: correctPair,
            isCorrect: true,
            userAnswer: 'จับคู่ถูกต้อง',
          ),
        );
      } else {
        // Wrong match - subtract 1 point
        score = (score - 1).clamp(0, double.infinity).toInt();

        // Show wrong match feedback
        wrongMatchIndexes = [selectedIndex!, i];
        _wrongMatchTimer?.cancel();
        _wrongMatchTimer = Timer(const Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() {
              wrongMatchIndexes.clear();
            });
          }
        });

        // Find which word was attempted and add result for incorrect match
        final attemptedWord = currentPairs.firstWhere(
          (w) => w.word == a || w.word == b,
          orElse: () => currentPairs.first,
        );

        results.add(
          GameResult(
            word: attemptedWord,
            isCorrect: false,
            userAnswer: 'จับคู่ผิด',
          ),
        );
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
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _wrongMatchTimer?.cancel();
    super.dispose();
  }

  Color getCardColor(int index) {
    if (matched[index]) return Colors.green;
    if (wrongMatchIndexes.contains(index)) return Colors.red;
    if (selectedIndex == index) return Colors.orange;
    return Colors.green.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จับคู่ รอบ $round/10'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(6.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFBFA2DB), Color(0xFFE0BBFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFBFA2DB).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$score',
                  style: const TextStyle(
                    fontSize: 16,
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
            colors: [Color(0xFFE0BBFF), Color(0xFFBFA2DB)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Card(
                          elevation: 12,
                          shadowColor: Color(0xFFBFA2DB).withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [Colors.white, Color(0xFFF3E8FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header with instructions
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.green.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        AnimatedBuilder(
                                          animation: _pulseAnimation,
                                          builder: (context, child) {
                                            return Transform.scale(
                                              scale: _pulseAnimation.value,
                                              child: Icon(
                                                Icons.link,
                                                color: Colors.green.shade600,
                                                size: 24,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'จับคู่คำกับความหมาย',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'แตะที่คำและความหมายที่ตรงกัน',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Game grid
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.blue.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: items.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio: 1.1,
                                          ),
                                      itemBuilder: (_, i) {
                                        final isSelected = selectedIndex == i;
                                        final isDone = matched[i];
                                        final isWrongMatch = wrongMatchIndexes
                                            .contains(i);

                                        return TweenAnimationBuilder<double>(
                                          tween: Tween<double>(
                                            begin: 0,
                                            end: 1,
                                          ),
                                          duration: Duration(
                                            milliseconds: 400 + (i * 100),
                                          ),
                                          builder: (context, value, child) {
                                            return Transform.scale(
                                              scale: value,
                                              child: Opacity(
                                                opacity: value,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap:
                                                        isDone
                                                            ? null
                                                            : () => _onTap(i),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors:
                                                              isDone
                                                                  ? [
                                                                    Colors
                                                                        .green
                                                                        .shade400,
                                                                    Colors
                                                                        .green
                                                                        .shade600,
                                                                  ]
                                                                  : isWrongMatch
                                                                  ? [
                                                                    Colors
                                                                        .red
                                                                        .shade400,
                                                                    Colors
                                                                        .red
                                                                        .shade600,
                                                                  ]
                                                                  : isSelected
                                                                  ? [
                                                                    Colors
                                                                        .orange
                                                                        .shade400,
                                                                    Colors
                                                                        .orange
                                                                        .shade600,
                                                                  ]
                                                                  : [
                                                                    Colors
                                                                        .green
                                                                        .shade300,
                                                                    Colors
                                                                        .green
                                                                        .shade500,
                                                                  ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                matched[i]
                                                                    ? Colors
                                                                        .green
                                                                        .withOpacity(
                                                                          0.3,
                                                                        )
                                                                    : wrongMatchIndexes
                                                                        .contains(
                                                                          i,
                                                                        )
                                                                    ? Colors.red
                                                                        .withOpacity(
                                                                          0.3,
                                                                        )
                                                                    : Color(
                                                                      0xFFBFA2DB,
                                                                    ).withOpacity(
                                                                      0.3,
                                                                    ),
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  3,
                                                                ),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color:
                                                              isWrongMatch
                                                                  ? Colors
                                                                      .red
                                                                      .shade800
                                                                  : isSelected
                                                                  ? Colors
                                                                      .orange
                                                                      .shade800
                                                                  : Colors.white
                                                                      .withOpacity(
                                                                        0.3,
                                                                      ),
                                                          width:
                                                              (isWrongMatch ||
                                                                      isSelected)
                                                                  ? 2
                                                                  : 1,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                6.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              if (isDone)
                                                                Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  size: 16,
                                                                ),
                                                              if (isWrongMatch)
                                                                Icon(
                                                                  Icons.close,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  size: 16,
                                                                ),
                                                              if (isDone ||
                                                                  isWrongMatch)
                                                                const SizedBox(
                                                                  height: 2,
                                                                ),
                                                              Text(
                                                                isWrongMatch
                                                                    ? 'ไม่ถูกต้อง'
                                                                    : items[i],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      isWrongMatch
                                                                          ? 10
                                                                          : 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      Colors
                                                                          .white,
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
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Progress indicator
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.purple.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'คู่ที่จับคู่แล้ว:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.purple.shade700,
                                          ),
                                        ),
                                        Text(
                                          '${matched.where((m) => m).length ~/ 2}/5',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple.shade700,
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
                      ),
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
