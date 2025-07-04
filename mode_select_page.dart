import 'package:flutter/material.dart';
import 'difficulty_page.dart';

class ModeSelectPage extends StatelessWidget {
  final Function(String, int) onStatUpdate;
  const ModeSelectPage({super.key, required this.onStatUpdate});

  @override
  Widget build(BuildContext context) {
    final modes = [
      {'name': 'สลับคำ', 'icon': Icons.shuffle_rounded},
      {'name': 'เติมคำ', 'icon': Icons.edit_note_rounded},
      {'name': 'จับคู่', 'icon': Icons.link_rounded},
      {'name': 'แข่งกับเวลา', 'icon': Icons.timer_rounded},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกโหมดเกม')),
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
                          'เลือกโหมดเกม',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...modes.map((mode) => Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: ListTile(
                            leading: Icon(mode['icon'] as IconData, color: Colors.deepOrange, size: 32),
                            title: Text(mode['name'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.deepOrange),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DifficultyPage(
                                    mode: mode['name'] as String,
                                    onStatUpdate: onStatUpdate,
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
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