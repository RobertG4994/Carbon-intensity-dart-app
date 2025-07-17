import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchCarbonIntensity(DateTime date) async {
  final dateString = date.toIso8601String().substring(0, 10); // YYYY-MM-DD
  final url = Uri.parse('https://api.carbonintensity.org.uk/intensity/date/$dateString');

  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to load data');
  }

  final jsonData = json.decode(response.body);
  final List<dynamic> data = jsonData['data'];
  return data.cast<Map<String, dynamic>>();
}