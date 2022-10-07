import 'package:flutter/material.dart';
import 'package:math_dash/game_screen.dart';
import 'package:math_dash/request_screen.dart';
import 'package:math_dash/respond_screen.dart';
import 'package:math_dash/main.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    void openGame() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GamePage(seed: 123),
        ),
      );
    }

    void openRespond() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RespondPage(),
        ),
      );
    }

    void openRequest() {
      //send request to opponent's ip

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RequestPage(),
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
              const Text(
                'Math Dash!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w900,
                    fontSize: 100),
              ),
              Text("My IP: ${_ipAddress!}"),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(hintText: "IP Address"),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: 250,
                  height: 75,
                  child: ElevatedButton(
                      key: const Key("InviteButton"),
                      onPressed: openRequest,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w400)),
                      child: const Text("Invite"))),
              const SizedBox(height: 10),

              // Button Below will not exist.
              // Button should be replaced with logic code that
              // relates to the network when a play request is sent.

              SizedBox(
                  width: 200,
                  height: 75,
                  child: ElevatedButton(
                      key: const Key("TempRespondButton"),
                      onPressed: openRespond,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      child: const Text("Respond Dev Button"))),
            ],
          ),
        ),
      ),
    );
  }
}
