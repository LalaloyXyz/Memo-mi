import 'package:flutter/material.dart';
import 'difficulty_page.dart';

class ModeSelectPage extends StatefulWidget {
  final Function(String, int) onStatUpdate;
  const ModeSelectPage({super.key, required this.onStatUpdate});

  @override
  State<ModeSelectPage> createState() => _ModeSelectPageState();
}

class _ModeSelectPageState extends State<ModeSelectPage>
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
    final modes = [
      {
        'name': 'สลับคำ',
        'icon': Icons.shuffle_rounded,
        // Pastel brown
        'color': const Color.fromARGB(255, 148, 201, 227),
        'colorLight': const Color.fromARGB(255, 148, 201, 227),
        'colorDark': const Color.fromARGB(255, 148, 201, 227),
        'description': 'เรียงลำดับตัวอักษรให้ถูกต้อง',
      },
      {
        'name': 'เติมคำ',
        'icon': Icons.edit_note_rounded,
        // Pastel brown
        'color': const Color.fromARGB(255, 152, 227, 112),
        'colorLight': const Color.fromARGB(255, 152, 227, 112),
        'colorDark': const Color.fromARGB(255, 152, 227, 112),
        'description': 'เติมตัวอักษรที่หายไป',
      },
      {
        'name': 'จับคู่',
        'icon': Icons.link_rounded,
        // Pastel brown
        'color': const Color.fromARGB(255, 247, 229, 89),
        'colorLight': const Color.fromARGB(255, 247, 229, 89),
        'colorDark': const Color.fromARGB(255, 247, 229, 89),
        'description': 'จับคู่คำกับความหมาย',
      },
      {
        'name': 'แข่งกับเวลา',
        'icon': Icons.timer_rounded,
        // Pastel brown
        'color': const Color.fromARGB(255, 255, 184, 112),
        'colorLight': const Color.fromARGB(255, 255, 184, 112),
        'colorDark': const Color.fromARGB(255, 255, 184, 112),
        'description': 'ตอบให้เร็วที่สุด',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกโหมดเกม'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/all_background.jpeg'),
            fit: BoxFit.cover,
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
                        const SizedBox(height: 32),
                        // Game modes
                        Expanded(
                          child: ListView.builder(
                            itemCount: modes.length,
                            itemBuilder: (context, index) {
                              final mode = modes[index];
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
                                        color: (mode['color'] as Color)
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => DifficultyPage(
                                                    mode:
                                                        mode['name'] as String,
                                                    onStatUpdate:
                                                        widget.onStatUpdate,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                mode['colorLight'] as Color,
                                                mode['colorDark'] as Color,
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
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ).withOpacity(0.2),
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
                                                    mode['icon'] as IconData,
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
                                                      Text(
                                                        mode['name'] as String,
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                            255,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        mode['description']
                                                            as String,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              const Color.fromARGB(
                                                                255,
                                                                0,
                                                                0,
                                                                0,
                                                              ).withOpacity(
                                                                0.8,
                                                              ),
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
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ).withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: Colors.white,
                                                    size: 20,
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
}
