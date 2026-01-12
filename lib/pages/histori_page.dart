import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/service_api.dart';

class HistoriPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HistoriPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "Histori Coding",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().getHistori(userData['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Gagal memuat data",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada histori absen",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var item = snapshot.data![index];
              // Melakukan format penanggalan dari database UpdatedAt
              DateTime date = DateTime.parse(item['updated_at']).toLocal();
              String formattedDate = DateFormat(
                'EEEE, d MMMM yyyy - HH:mm',
                'id_ID',
              ).format(date);

              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      item['description'] ??
                          "-", // Ambil deskripsi yang diinput dan dari database
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  leading: const Icon(Icons.code, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
