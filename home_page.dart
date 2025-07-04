import 'package:flutter/material.dart';
import 'mode_select_page.dart';

class HomePage extends StatelessWidget {
  final String email;
  final VoidCallback onLogout;
  final Map<String, int> stats;
  final Function(String, int) onStatUpdate;

  const HomePage({
    super.key,
    required this.email,
    required this.onLogout,
    required this.stats,
    required this.onStatUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                minWidth: double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 255, 219, 219),
                          radius: 28,
                          child: Icon(
                            Icons.person,
                            color: Colors.deepOrange[700],
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สวัสดี $email',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'ยินดีต้อนรับกลับมา',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.deepOrange,
                            size: 28,
                          ),
                          tooltip: 'ออกจากระบบ',
                          onPressed: onLogout,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
                        elevation: 12,
                        shadowColor: Colors.deepOrange.withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback:
                                    (bounds) => const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 58, 58, 58),
                                        Color.fromARGB(255, 59, 59, 59),
                                      ],
                                    ).createShader(bounds),
                                child: const Text(
                                  'คะแนนรวมในแต่ละโหมด:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...stats.entries.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _modeIcon(e.key),
                                        color: Colors.deepOrange,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${e.key}: ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${e.value} คะแนน',
                                        style: const TextStyle(fontSize: 16),
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
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        ModeSelectPage(onStatUpdate: onStatUpdate),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            shadowColor: Colors.deepOrange.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ).copyWith(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepOrange[400]!,
                                  Colors.deepOrange[600]!,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_arrow_rounded, size: 24),
                                  SizedBox(width: 8),
                                  Text('เริ่มเล่น'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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

IconData _modeIcon(String mode) {
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
      return Icons.star;
  }
}
