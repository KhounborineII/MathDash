import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_dash/communication.dart';
import 'package:math_dash/main.dart';
import 'package:math_dash/game_screen.dart';

int ourPort = 8888;

class RespondPage extends StatefulWidget {
  const RespondPage({super.key, required this.host});

  final String host;

  @override
  State<RespondPage> createState() => _RespondPageState();
}

class _RespondPageState extends State<RespondPage> {

  Future<void> sendRsvp(bool rsvp, [int? seed]) async {
    if (rsvp) assert (seed != null);
    
    Message rsvpMessage = Message(2, MessageType.rsvp, {
      'response': rsvp, 
      'seed': rsvp ? seed! : -1
    });
    var jsonMessage = rsvpMessage.toJson();
    String stringMessage = json.encode(jsonMessage);
    print("sending an rsvp: '$stringMessage'");

    // Modeled after Friend.send in text_messenger/friends_data.dart:
    Socket socket = await Socket.connect(widget.host, ourPort);
    socket.write(stringMessage);
    socket.close();
  }

  @override
  Widget build(BuildContext context) {
    void openGame() {
    Screens.currentScreen = Screens.gameScreen;
    int seedToUse = Random().nextInt(1<<16);
    sendRsvp(true, seedToUse);
    Screens.goToGameScreen(context, seedToUse);
    }

    void openHome() {
      Screens.currentScreen = Screens.homeScreen;
      sendRsvp(false);
      Navigator.pop(context);
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
                'Opponent From IP: ${widget.host} Is Challenging You!',
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
