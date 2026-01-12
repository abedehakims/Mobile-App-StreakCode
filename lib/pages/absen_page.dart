import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../services/service_api.dart';

class AbsenPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AbsenPage({super.key, required this.userData});

  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  final TextEditingController _deskripsiController = TextEditingController();
  late String _timeString = "";
  late Timer _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getTime());
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Stop timer setelah user meninggalkan halaman agar tidak berat
    super.dispose();
  }

  void getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  void _kirimAbsen() async {
    if (_deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Isi deskripsi belajar dahulu sebelum absen"),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      // API Calling dari database go
      // mengirim user_id sama description
      final res = await ApiService().submitAbsen(
        widget.userData['id'],
        _deskripsiController.text,
      );

      if (res['message'] != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res['message'])));
      }

      // Kembali ke home setelah sukses mengisi
      if (res['data'] != null) {
        final updatedUserData = res['data'];
        Navigator.pop(context, updatedUserData);
      } else {
        // User mengisi lagi jika backend error (gagal update parse data ke tabel users)
      }
    } catch (e) {
      print("Error Absen : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal terhubung ke server, silahkan coba lagi."),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "Absen Coding",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Column(
                children: [
                  const Text(
                    "WAKTU SAAT INI",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _timeString.isEmpty ? "--:--:--" : _timeString,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    DateFormat(
                      'EEEE, d MMMM yyyy',
                      'id_ID',
                    ).format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Apa yang kamu pelajari / lanjuti di coding hari ini?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _deskripsiController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText:
                    "Contoh : Saya hari ini belajar Python tentang For Loops dan While Loops",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _kirimAbsen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "SUBMIT ABSEN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
