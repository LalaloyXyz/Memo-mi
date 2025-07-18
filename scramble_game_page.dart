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

class _ScrambleGamePageState extends State<ScrambleGamePage>
    with TickerProviderStateMixin {
  late List<WordItem> questions;
  late WordItem current;
  late List<String> scrambled;
  List<int> selectedIndexes = [];
  int round = 1;
  int score = 0;
  List<GameResult> results = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
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

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

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
    _animationController.reset();
    _animationController.forward();
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

  void _reset() {
    setState(() {
      selectedIndexes.clear();
    });
  }

  void _submit() {
    final attempt = selectedIndexes.map((i) => scrambled[i]).join();
    final isCorrect = attempt == current.word.toUpperCase();

    results.add(
      GameResult(word: current, isCorrect: isCorrect, userAnswer: attempt),
    );

    if (isCorrect) {
      score++;
    }
    round++;
    _nextRound();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สลับคำ รอบ $round/10'),
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
                                    const SizedBox(height: 20),

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
                                                                scrambled[i],
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
                                                                        _remove(
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
                                              scrambled.length,
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
                                                                        _select(
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
                                                                  scrambled[i],
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

                                    // Action buttons with enhanced styling
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _reset,
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              foregroundColor:
                                                  Colors.grey.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.refresh_rounded,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 6),
                                                const Text('ล้าง'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              textStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
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
