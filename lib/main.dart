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
        colorScheme: _customColorScheme,
      ),
      home: const MyHomePage(title: 'Math Dash!'),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => const GamePage(seed: 123),
        '/b': (BuildContext context) => const GameOverPage(),
        '/c': (BuildContext context) => const MyHomePage(title: "Math Dash"),
      },
    );
  }
}

// Thank you, https://sanjibsinha.com/color-flutter/
const ColorScheme _customColorScheme = ColorScheme(
  primary: Colors.orange,
  secondary: Colors.orange,
  surface: Colors.red,
  background: customSurfaceWhite,
  error: customMagenta900,
  onPrimary: Colors.black,
  onSecondary: Colors.deepOrange,
  onSurface: Colors.white,
  onBackground: customMagenta100,
  onError: Colors.redAccent,
  brightness: Brightness.dark,
);
const Color customMagenta100 = Color(0xfffaac9d);
const Color customMagenta900 = Color(0xfff4310a);
const Color customErrorRed = Color(0xFFC5032B);
const Color customSurfaceWhite = Color(0xFFFFFBFA);
