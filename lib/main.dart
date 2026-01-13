import 'package:aplikasi_absensi_coding_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeDateFormatting('id_ID', null);
    runApp(const MyApp());
  } catch (e) {
    print("Error dalam inisialisasi format tanggal: $e");
    runApp(const MyApp());
  }
  // Memulai format penanggalan
  await NotificationService().init();
  // Meminta izin notifikasi jika Android 13+
  await NotificationService().requestPermission();
  // Memasang jadwal yaitu jam 11 pagi
  await NotificationService().scheduleDailyElevenAM();
  // Inisiasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StreakCode',
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.blue),
      home: LoginPage(),
    );
  }
}
