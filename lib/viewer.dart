import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'color.dart';

class IntensityGraph extends StatefulWidget {
  final String dateString;

  const IntensityGraph({super.key, required this.dateString});

  @override
  State<IntensityGraph> createState() => _IntensityGraphState();
}

class _IntensityGraphState extends State<IntensityGraph> {
  bool isLoading = true;
  String? errorMessage;

  List<IntervalData> intervals = [];

  @override
  void initState() {
    super.initState();
    fetchIntensityData();
  }

  Future<void> fetchIntensityData() async {
    final url = Uri.parse('https://api.carbonintensity.org.uk/intensity/date/${widget.dateString}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic>? dataList = jsonData['data'];

        if (dataList != null && dataList.isNotEmpty) {
          intervals = dataList.map((entry) {
            final intensity = entry['intensity'];
            return IntervalData(
              from: DateTime.parse(entry['from']),
              actual: intensity['actual'].toDouble(),
              index: intensity['index'].toString()
            );
          }).toList();

          setState(() {
            isLoading = false;
            errorMessage = null;
          });
        } else {
          setState(() {
            errorMessage = "No data available for ${widget.dateString}";
            isLoading = false;
            print("No available data");
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to load data: ${response.statusCode}";
          isLoading = false;
          print( "Failed to load data: ${response.statusCode}");
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
         print('Error occurred: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) return Center(child: Text("An error has occured, please try again or contact support.", style: const TextStyle(color: Colors.red)));

    final maxActual = intervals.map((e) => e.actual).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Center(
          child:Container(
            padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
             boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), 
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 0),
              ),
            ],
            color: const Color.fromARGB(170, 0, 0, 0),  
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child:Text('Carbon Intensity for ${widget.dateString}',textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 242, 246, 232))),
          ),),),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: intervals.map((interval) {
                  final barHeight = (interval.actual / maxActual) * 150; 
                  final index = intervals.indexOf(interval);
                  final timeLabel = "${interval.from.hour.toString().padLeft(2, '0')}:${interval.from.minute.toString().padLeft(2, '0')}";

                  return Container(
                    width: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Number on top of the bar
                        Text(interval.actual.toStringAsFixed(0), style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold, color: Color.fromARGB(255, 242, 246, 232))),
                        const SizedBox(height: 4),
                        // Bar
                        Container(
                          height: barHeight,
                          color: getBorderColor(interval.index),
                        ),
                        const SizedBox(height: 4),
                        if (index % 4 == 0) Text(timeLabel, style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold, color: Color.fromARGB(255, 242, 246, 232))) else const SizedBox(height: 14),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class IntervalData {
  final DateTime from;
  final double actual;
  final String index;

  IntervalData({required this.from, required this.actual, required this.index});
}