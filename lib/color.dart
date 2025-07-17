import 'package:flutter/material.dart';

Color getBorderColor(String index){
  switch(index){
    case 'very low':
    return const Color.fromARGB(255, 3, 82, 7);
    case 'low':
    return const Color.fromARGB(255, 9, 135, 15);
    case 'moderate':
    return const Color.fromARGB(255, 150, 210, 72);
    case 'high':
    return const Color.fromARGB(255, 222, 148, 10);
    case 'very high':
    return const Color.fromARGB(255, 203, 33, 17);
    default:
     return const Color.fromARGB(255, 75, 75, 74);
  }
 }