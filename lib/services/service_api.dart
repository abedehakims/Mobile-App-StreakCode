import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

  Future<Map<String, dynamic>> login(String nama) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nama": nama}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> submitAbsen(
    int userId,
    String description,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/absen"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "description": description}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getUserData(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/user/$userId"));
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getHistori(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/histori/$userId"));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return body['data'];
    } else {
      throw Exception("Gagal mengambil histori");
    }
  }
}
