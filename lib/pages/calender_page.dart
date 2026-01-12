import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/service_api.dart';

class CalenderPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CalenderPage({super.key, required this.userData});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // Map untuk menyimpan event berdasarkan tanggal
  Map<DateTime, List<dynamic>> _events = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchHistoryData();
  }

  void _fetchHistoryData() async {
    try {
      // Memanggil API getHistori di service_api.dart
      final List<dynamic> historyData = await ApiService().getHistori(
        widget.userData['id'],
      );
      Map<DateTime, List<dynamic>> data = {};
      for (var item in historyData) {
        // Parse data tipe string ke updated_at DateTime
        DateTime originalDate = DateTime.parse(item['updated_at']).toLocal();
        DateTime dateKey = DateTime(
          originalDate.year,
          originalDate.month,
          originalDate.day,
        );
        if (data[dateKey] == null) data[dateKey] = [];
        data[dateKey]!.add(item);
      }
      setState(() {
        _events = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error mengambil data Histori $e");
      setState(() => _isLoading = false);
    }
  }

  // Helper untuk si kalender mengambil data dari map
  List<dynamic> _getEventsForDay(DateTime day) {
    // Normalize day yang ada di kalender
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Kalender Streak',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                // Widget Kalender
                _buildTableCalender(),
                const SizedBox(height: 20),
                const Divider(color: Colors.grey),
                // Penjelasan orange streak dot
                Expanded(
                  child: Center(
                    child: Text(
                      "🟠 : menandakan hari kamu melakukan absen coding.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTableCalender() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          calendarFormat: _calendarFormat,
          // Menghubungkan data event ke kalender
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,

          // Header Style
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Colors.lightGreenAccent,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Colors.lightGreenAccent,
            ),
          ),
          // Style hari di kalender
          calendarStyle: const CalendarStyle(
            defaultTextStyle: TextStyle(color: Colors.white),
            weekendTextStyle: TextStyle(color: Colors.red),
            outsideTextStyle: TextStyle(color: Colors.grey),
            // Style hari ini
            todayDecoration: BoxDecoration(
              color: Colors.lightGreenAccent,
              shape: BoxShape.circle,
            ),
            // Style hari yang dipilih user
            selectedDecoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
          // Tampilan Streak berbentuk dot / titik
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 255, 123, 0),
                      boxShadow: [BoxShadow(color: Colors.orange)],
                    ),
                    width: 10,
                    height: 10,
                  ),
                );
              }
              return null;
            },
          ),
          // Interaksi klik
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() => _calendarFormat = format);
            }
          },
          onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        ),
      ),
    );
  }
}
