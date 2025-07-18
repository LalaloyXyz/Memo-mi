import 'package:flutter/material.dart';
import 'dart:ui';
import 'mode_select_page.dart';

class HomePage extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;
  final Map<String, int> stats;
  final Function(String, int) onStatUpdate;

  const HomePage({
    super.key,
    required this.username,
    required this.onLogout,
    required this.stats,
    required this.onStatUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/all_background.jpeg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(
                  overscroll: false,
                  physics: const BouncingScrollPhysics(),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top right logout button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Color.fromARGB(255, 70, 34, 0),
                              size: 28,
                            ),
                            onPressed: onLogout,
                            tooltip: 'Logout',
                          ),
                        ],
                      ),
                      // Avatar Card
                      Card(
                        elevation: 6,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF8D6E63), // brown
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF8D6E63,
                                      ).withOpacity(0.18),
                                      blurRadius: 16,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.waving_hand,
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          197,
                                          39,
                                        ), // brown
                                        size: 22,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Welcome',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(
                                            0xFF5D4037,
                                          ), // darker brown
                                          letterSpacing: 1.1,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black12,
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF8D6E63), // brown
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Total Score Card
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 600),
                        builder:
                            (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 30),
                                child: child,
                              ),
                            ),
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF8D6E63,
                                    ).withOpacity(0.08), // brown
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Color(
                                      0xFFF9A826,
                                    ), // keep gold for star
                                    size: 36,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total Score',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF8D6E63), // brown
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${stats.values.fold(0, (sum, score) => sum + score)}',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF222B45),
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
                      const SizedBox(height: 18),
                      // Individual Scores Card
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 800),
                        builder:
                            (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 40),
                                child: child,
                              ),
                            ),
                        child: Card(
                          elevation: 8,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mode Scores',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF8D6E63), // brown
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...stats.entries.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          modeEmoji(e.key),
                                          style: const TextStyle(fontSize: 28),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${e.key} ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: Color(0xFF8D6E63), // brown
                                          ),
                                        ),
                                        Text(
                                          '${e.value}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(
                                              0xFF5D4037,
                                            ), // darker brown
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // (Play button only in bottomNavigationBar now)
                      const SizedBox(height: 24),
                      _CutePlayButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ModeSelectPage(
                                    onStatUpdate: onStatUpdate,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String modeEmoji(String mode) {
  switch (mode) {
    case 'สลับคำ':
      return '🔀';
    case 'เติมคำ':
      return ' ✍️ ';
    case 'จับคู่':
      return '🧩';
    case 'แข่งกับเวลา':
      return '⏱️';
    default:
      return '🎮';
  }
}

class _CutePlayButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _CutePlayButton({required this.onPressed});

  @override
  State<_CutePlayButton> createState() => _CutePlayButtonState();
}

class _CutePlayButtonState extends State<_CutePlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.05,
      value: 1.0,
    );
    _scaleAnim = _controller.drive(Tween(begin: 1.0, end: 1.05));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8D6E63).withOpacity(0.18),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D6E63), // brown
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, size: 24),
                    SizedBox(width: 5),
                    Text('Play'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
