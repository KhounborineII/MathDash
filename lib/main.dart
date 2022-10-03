import 'package:flutter/material.dart';
import 'package:math_dash/home_screen.dart';
import 'package:math_dash/game_screen.dart';
import 'package:math_dash/game_over_screen.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Dash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Math Dash!'),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => const GamePage(),
        '/b': (BuildContext context) => const GameOverPage(),
        '/c': (BuildContext context) => const MyHomePage(title: "Math Dash"),
      },
    );
  }
}
