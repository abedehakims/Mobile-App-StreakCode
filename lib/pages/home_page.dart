import 'package:aplikasi_absensi_coding_flutter/pages/absen_page.dart';
import 'package:aplikasi_absensi_coding_flutter/pages/histori_page.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_absensi_coding_flutter/services/service_api.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_absensi_coding_flutter/pages/calender_page.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomePage({super.key, required this.userData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ambil data user dari database
  late String nama;
  late int streakCount;
  bool isAlreadyAbsenToday = false;

  @override
  void initState() {
    super.initState();
    // 1. Mapping data dasar
    nama = widget.userData['nama'] ?? "User";
    streakCount = widget.userData['current_streak'] ?? 0;

    // Melakukan Cek manual apakah last_absen adalah hari ini
    if (widget.userData['last_absen'] != null) {
      try {
        // Mengambil waktu last_absen dan konversi ke Waktu Lokal
        DateTime lastAbsenDate = DateTime.parse(
          widget.userData['last_absen'],
        ).toLocal();
        DateTime now = DateTime.now();

        // Menyamakan dan membandingkan Tahun, Bulan, dan Tanggal (abaikan jam)
        bool isSameDay =
            lastAbsenDate.year == now.year &&
            lastAbsenDate.month == now.month &&
            lastAbsenDate.day == now.day;

        isAlreadyAbsenToday = isSameDay;
      } catch (e) {
        print("Error parsing date di Home: $e");
        isAlreadyAbsenToday = false;
      }
    } else {
      // Untuk pengguna baru yang belum absen
      isAlreadyAbsenToday = false;
    }
  }

  void _refreshUserData() async {
    try {
      final res = await ApiService().getUserData(widget.userData['id']);
      setState(() {
        streakCount = res['data']['current_streak'] ?? 0;
        isAlreadyAbsenToday = res['data']['is_today'] ?? false;
      });
    } catch (e) {
      print("Gagal refresh data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat(
      'EEEE, d MMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          // ====== Header hitam, dengan striping biru bawah dan ada nama aplikasi serta sapaan user ======
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nama aplikasi
                  const Text(
                    "StreakCode",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Row(
                    children: [
                      // Sapaan ke user
                      Text(
                        "Hai, $nama!!",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 18,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ====== Grid menu dengan 4 fitur utama berjumlah 4 box di tengah layar ======
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    children: [
                      // Fungsi tombol dan grid item
                      // Item 1 : Absens coding, persegi berwarna merah dan icon kertas
                      buildMenuButton(
                        title: "Absen Coding",
                        icon: Icons.edit_document,
                        color: Colors.redAccent,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AbsenPage(userData: widget.userData),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              streakCount = result['current_streak'];
                              isAlreadyAbsenToday = true;
                            });
                            // Memanggil opsi untuk fetch data terbaru dari backend jika berhasil absen lalu refresh data
                            _refreshUserData();
                          }
                        },
                      ),
                      // Item 2 : Streak, persegi berwarna abu-abu jika belum streak, orange ketika streak
                      buildDisplayCard(
                        title: "Streak",
                        value: "$streakCount Hari",
                        icon: Icons.local_fire_department,
                        color: isAlreadyAbsenToday
                            ? const Color.fromARGB(255, 255, 123, 0)
                            : Colors.grey,
                        textColor: Colors.white,
                      ),
                      // Item 3 : Histori, persegi berwarna biru dengan fungsi menampilkan histori absen user
                      buildMenuButton(
                        title: "Histori",
                        icon: Icons.history,
                        color: Colors.lightBlueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HistoriPage(userData: widget.userData),
                            ),
                          );
                        },
                      ),
                      // Item 4 : Kalender, persegi berwarna hijau dengan fungsi menampilkan kalender dan checklist tanggal
                      buildMenuButton(
                        title: "Kalender Streak",
                        icon: Icons.calendar_month,
                        color: Colors.lightGreenAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CalenderPage(userData: widget.userData),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer kecil tanggalan
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Column(
                children: [
                  Text(
                    todayDate,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Made By KitaNgoding Studio",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Setting tombol Widget (buildMenuButton)
  Widget buildMenuButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Setting tombol widget (buildDisplayCard)
  Widget buildDisplayCard({
    required String value,
    required String title,
    required IconData icon,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 2)),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: textColor),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: textColor.withValues(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
