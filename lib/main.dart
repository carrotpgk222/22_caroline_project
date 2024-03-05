import 'package:flutter/material.dart';
import './gpa.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'ClearFont',
      ),
      home: const GPAHomePage(),
    );
  }
}

