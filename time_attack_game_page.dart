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

class _TimeAttackGamePageState extends State<TimeAttackGamePage>
    with TickerProviderStateMixin {
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

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _timerController;
  late Animation<double> _timerAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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

    _timerController = AnimationController(
      duration: const Duration(seconds: maxTime),
      vsync: this,
    );

    _timerAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _timerController, curve: Curves.linear));

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

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
    _animationController.reset();
    _animationController.forward();
    _timerController.reset();
    _timerController.forward();
    _startTimer();
    setState(() {});
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft <= 0) {
        t.cancel();
        // Time ran out, add result as incorrect
        results.add(
          GameResult(word: current, isCorrect: false, userAnswer: 'หมดเวลา'),
        );
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

    results.add(
      GameResult(word: current, isCorrect: isCorrect, userAnswer: attempt),
    );

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
    _animationController.dispose();
    _timerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _getTimerColor() {
    if (timeLeft > 6) return Colors.green;
    if (timeLeft > 3) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แข่งกับเวลา รอบ $round/10'),
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
          image: DecorationImage(
            image: AssetImage('assets/all_background.jpeg'),
            fit: BoxFit.cover,
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
                child: SingleChildScrollView(
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
                                    // Emoji without frame
                                    AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _pulseAnimation.value,
                                          child: Text(
                                            current.emoji,
                                            style: const TextStyle(
                                              fontSize: 48,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // Meaning with enhanced styling
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.purple.shade50,
                                            Colors.purple.shade100,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.purple.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        'คำแปล: ${current.meaning}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Enhanced timer display
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: _getTimerColor().withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _getTimerColor().withOpacity(
                                            0.3,
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.timer,
                                                color: _getTimerColor(),
                                                size: 20,
                                              ),
                                              Text(
                                                'เวลาที่เหลือ: $timeLeft วินาที',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: _getTimerColor(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          AnimatedBuilder(
                                            animation: _timerAnimation,
                                            builder: (context, child) {
                                              return Container(
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.grey.shade200,
                                                ),
                                                child: FractionallySizedBox(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  widthFactor:
                                                      _timerAnimation.value,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          _getTimerColor(),
                                                          _getTimerColor()
                                                              .withOpacity(0.7),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Selected letters with enhanced styling
                                    if (selectedIndexes.isNotEmpty) ...[
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.green.withOpacity(
                                              0.3,
                                            ),
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'คำที่เลือก:',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green.shade700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 6,
                                              children:
                                                  selectedIndexes
                                                      .map(
                                                        (i) => Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 6,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                Colors
                                                                    .green
                                                                    .shade100,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            border: Border.all(
                                                              color: Colors
                                                                  .green
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                letters[i],
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      Colors
                                                                          .green
                                                                          .shade800,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () =>
                                                                        _removeLetter(
                                                                          i,
                                                                        ),
                                                                child: Icon(
                                                                  Icons.close,
                                                                  size: 14,
                                                                  color:
                                                                      Colors
                                                                          .green
                                                                          .shade600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],

                                    // Available letters with enhanced styling
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
                                      child: Column(
                                        children: [
                                          Text(
                                            'ตัวอักษรที่ใช้ได้:',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: List.generate(
                                              letters.length,
                                              (i) => TweenAnimationBuilder<
                                                double
                                              >(
                                                tween: Tween<double>(
                                                  begin: 0,
                                                  end: 1,
                                                ),
                                                duration: Duration(
                                                  milliseconds: 300 + (i * 100),
                                                ),
                                                builder:
                                                    (
                                                      context,
                                                      value,
                                                      child,
                                                    ) => Transform.scale(
                                                      scale:
                                                          selectedIndexes
                                                                  .contains(i)
                                                              ? 0.8
                                                              : value,
                                                      child: Opacity(
                                                        opacity:
                                                            selectedIndexes
                                                                    .contains(i)
                                                                ? 0.5
                                                                : value,
                                                        child: Material(
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                          child: InkWell(
                                                            onTap:
                                                                selectedIndexes
                                                                        .contains(
                                                                          i,
                                                                        )
                                                                    ? null
                                                                    : () =>
                                                                        _onTap(
                                                                          i,
                                                                        ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            child: Container(
                                                              width: 48,
                                                              height: 48,
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors:
                                                                      selectedIndexes.contains(
                                                                            i,
                                                                          )
                                                                          ? [
                                                                            Colors.grey.shade300,
                                                                            Colors.grey.shade400,
                                                                          ]
                                                                          : [
                                                                            Colors.blue.shade400,
                                                                            Colors.blue.shade600,
                                                                          ],
                                                                  begin:
                                                                      Alignment
                                                                          .topLeft,
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
                                                                    color: Color(
                                                                      0xFFBFA2DB,
                                                                    ).withOpacity(
                                                                      0.2,
                                                                    ),
                                                                    blurRadius:
                                                                        6,
                                                                    offset:
                                                                        const Offset(
                                                                          0,
                                                                          3,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  letters[i],
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        selectedIndexes.contains(
                                                                              i,
                                                                            )
                                                                            ? Colors.grey.shade600
                                                                            : Colors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
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
                                    const SizedBox(height: 16),

                                    // Enhanced submit button
                                    Container(
                                      width: double.infinity,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(
                                              0xFFBFA2DB,
                                            ).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed:
                                            selectedIndexes.isEmpty
                                                ? null
                                                : _submit,
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor:
                                              Colors.deepOrange.shade600,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 6),
                                            const Text('ยืนยัน'),
                                          ],
                                        ),
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
      ),
    );
  }
}
