import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_dash/home_screen.dart';
import 'package:math_dash/game_screen.dart';

class RespondPage extends StatefulWidget {
  const RespondPage({super.key});

  @override
  State<RespondPage> createState() => _RespondPageState();
}

class _RespondPageState extends State<RespondPage> {
  String opponentIP = "PLACEHOLDER IP TEXT";
  late int timeLeft;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    timeLeft = 10;
    timer = Timer.periodic(const Duration(seconds: 1), countdown);
  }

  void countdown(Timer t) {
    if (timeLeft > 0) {
      setState(() {
        timeLeft--;
      });
    } else {
      // an end message would be sent here
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "Math Dash!"),
          ),
        );
      });
      t.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    void openGame() {
      dispose();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GamePage(seed: 123),
        ),
      );
    }

    void openHome() {
      dispose();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "Math Dash!"),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.timer_outlined,
                color: Colors.white,
                size: 50,
              ),
              Text(
                '$timeLeft',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
                key: const Key('timeLeftText'),
              ),
              const SizedBox(height: 50),
              Text(
                'Opponent From IP: $opponentIP Is Challenging You!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      key: const Key("PlayButton"),
                      onPressed: openGame,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 30)),
                      child: const Text("Play"))),
              const SizedBox(height: 10),
              SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      key: const Key("DenyButton"),
                      onPressed: openHome,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 30)),
                      child: const Text("Deny"))),
            ],
          ),
        ),
      ),
    );
  }
}
