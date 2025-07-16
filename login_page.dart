import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function(String) onLogin;
  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameCtl = TextEditingController();
  String? error;
  bool isLoading = false;

  @override
  void dispose() {
    usernameCtl.dispose();
    super.dispose();
  }

  void submit() async {
    final username = usernameCtl.text.trim();
    if (username.isEmpty) {
      setState(() => error = 'กรุณากรอกชื่อผู้ใช้');
      return;
    }
    setState(() {
      isLoading = true;
      error = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
    widget.onLogin(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpeg', // <-- Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(child: Container()), // Pushes the frame to the bottom
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 212, 101),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 25,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: usernameCtl,
                      label: 'Username',
                      icon: Icons.person_outline,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: error != null ? 36 : 0,
                      child:
                          error != null
                              ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.brown[600],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        error!,
                                        style: TextStyle(
                                          color: Colors.brown[700],
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : const SizedBox(),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : submit,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color.fromARGB(255, 70, 34, 0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Log in'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 32, // Adjust as needed
                color: const Color.fromARGB(255, 255, 212, 101),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 70, 34, 0),
            width: 2,
          ),
        ),
      ),
    );
  }
}
