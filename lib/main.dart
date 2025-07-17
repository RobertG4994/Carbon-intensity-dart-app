import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'viewer.dart';
import 'color.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String index = "Loading...";
  String forecast = "Loading...";
  String actual = "Loading...";
 String rawIndex = "";
 
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
  final url = Uri.parse('https://api.carbonintensity.org.uk/intensity'); 
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final List<dynamic>? dataList = jsonData['data'];
      if (dataList != null && dataList.isNotEmpty) {
         final item = dataList[0]['intensity'];
          final fetchedIndex = item['index'].toString();
          final fetchedForecast = item['forecast'].toString();
          final fetchedActual = item['actual'].toString();
        setState(() {
            index = fetchedIndex;
            forecast = fetchedForecast;
            actual = fetchedActual;
        });
      } else {
        setState(() {
          index = 'No data available';
        });
      }
    } else {
      setState(() {
        index = 'Failed to load data (${response.statusCode})';
      });
    }
  } catch (e) {
    setState(() {
      index = 'Error: $e';
    });
  }
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.grey,
    appBar: AppBar(backgroundColor: Colors.grey,),
   body: 
    Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('Carbon Intensity Now', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    const SizedBox(height: 32), // spacing from top
    Align(
      alignment: Alignment.topCenter,
      child: Card(
        elevation: 4,
        color: const Color.fromARGB(170, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: getBorderColor(index),
            width: 10,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, // text aligned to left
            children: [
              Text('Forecast:', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232))),
            
              Text('$forecast, gCO2/kWh', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 242, 246, 232))),
              
              Text('Actual:', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232))),
            
              Text('$actual, gCO2/kWh', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color:Color.fromARGB(255, 242, 246, 232))),
             
              Text('Index:', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232))),
              Text( index.toUpperCase(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232) ), ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: IntensityGraph(dateString: '2025-07-16'),
        ),
      ],
    ),
  );
}
}
  //DateTime now = DateTime.now();
//String isoDate = now.toIso8601String();