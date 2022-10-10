import 'dart:async';

import 'package:flutter/material.dart';
import 'package:math_dash/main.dart';
import 'package:math_dash/game_screen.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key, required this.invitee});

  final String invitee;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int timeLeft = 60;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), countdown);
  }
  
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void countdown(Timer t) {
    if (timeLeft > 0) {
      setState(() {
        timeLeft--;
      });
    } else {
      // an end message would be sent here
      t.cancel();
      Screens.goToHomeScreen(context);
    }
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
      Screens.goToHomeScreen(context);
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Will be changed when IP and Networking is developed.
            // Widget should no longer be const,
            // and text should contain entered IP Address.

            // MAKE SURE TIMER IS DISPOSED OF WHEN CONNECTION IS MADE
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
                'Requesting to Battle Opponent at IP: ${widget.invitee}',
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
                      key: const Key("CancelButton"),
                      onPressed: openHome,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 40)),
                      child: const Text("Cancel"))),
            ],
          ),
        ),
      ),
    );
  }
}
