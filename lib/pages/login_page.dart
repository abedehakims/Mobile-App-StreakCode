import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../services/service_api.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _namaController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_namaController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final res = await ApiService().login(_namaController.text);

      if (res['data'] != null) {
        // Navigasi ke homepage sambil bawa data User dari input
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userData: res['data']),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selamat datang, ${res['data']['nama']}!")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar aplikasi
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/Logo.png',
                height: 160,
                width: 160,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 45),
            // Animasi mengetik kalimat sapaan
            SizedBox(
              height: 30,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "Selamat datang di StreakCode",
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 45),
                    ),
                    TypewriterAnimatedText(
                      "Siap lanjut coding hari ini?",
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 45),
                    ),
                  ],
                  repeatForever: true,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Box Input nama
            TextField(
              controller: _namaController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Masukkan Nama Kamu",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        "MASUK",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
