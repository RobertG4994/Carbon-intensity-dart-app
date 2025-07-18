import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'viewer.dart';
import 'color.dart';
import 'package:intl/intl.dart';
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
          print('No data available');
        });
      }
    } else {
      setState(() {
        index = 'Failed to load data (${response.statusCode})';
        print('Failed to load data ${response.statusCode}');
      });
    }
  } catch (e) {
    setState(() {
      index = 'Error: $e';
      print('Error occurred: $e');
    });
  }
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(backgroundColor:Color.fromARGB(170, 0, 0, 0),),
    body: Container(
   color: const Color.fromARGB(170, 0, 0, 0),
    child:Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    const SizedBox(height: 32),
    Align(
      alignment: Alignment.topCenter,
      child: Card(
        elevation: 4,
        color: const Color.fromARGB(170, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: getBorderColor(index),
            width: 10,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Container(
              child:Text('Current Carbon Intensity ', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 242, 246, 232))),
              padding: const EdgeInsets.all(20)),
              Text('Forecast', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232))),
              Text('$forecast, gCO2/kWh', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 242, 246, 232))),
              Text('Actual', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232))),
              Text('$actual, gCO2/kWh', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color:Color.fromARGB(255, 242, 246, 232))),
              Text('Index', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232))),
              Text( index.toUpperCase(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232) ), ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child:Container(
            padding: const EdgeInsets.all(40),
            child: IntensityGraph(dateString: formattedYesterdayDate),)
       
        ),
      ],
    ),
  )
  );
}
}
//using today's date does not work
//the api only responds to yesterday's date and before otherwise an error appears
//the user will get yesterday's data
 DateTime yesterdayDate = DateTime.now().subtract(Duration(days: 1));
String formattedYesterdayDate = DateFormat('yyyy-MM-dd').format(yesterdayDate);