import 'dart:io';

import 'package:flutter/material.dart';
import 'package:math_dash/communication.dart';
import 'package:math_dash/main.dart';
import 'package:math_dash/game_screen.dart';

class RespondPage extends StatefulWidget {
  const RespondPage({super.key});

  @override
  State<RespondPage> createState() => _RespondPageState();
}

class _RespondPageState extends State<RespondPage> {
  String opponentIP = "PLACEHOLDER IP TEXT";

  Future<void> sendRSVP(String opponent_IP) async {
    Socket socket = await Socket.connect(opponent_IP, 8888);
    socket.write(Message(1, MessageType.rsvp, {"response": true, "seed": 123}));
    socket.close();
  }

  @override
  Widget build(BuildContext context) {
    void openGame() {
      sendRSVP(opponentIP);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GamePage(seed: 123),
        ),
      );
    }

    Future<void> sendIgnore(String opponent_IP) async {
      Socket socket = await Socket.connect(opponent_IP, 8888);
      socket.write(Message(1, MessageType.ignore, {}));
      socket.close();
    }

    void openHome() {
      sendIgnore(opponentIP);
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
