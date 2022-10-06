import 'package:flutter/material.dart';
import 'package:math_dash/game_screen.dart';
import 'package:math_dash/request_screen.dart';
import 'package:math_dash/respond_screen.dart';

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

    void openRequest() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RequestPage(),
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

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                          textStyle: const TextStyle(fontSize: 40)),
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
                          textStyle: const TextStyle(fontSize: 15)),
                      child: const Text("Respond Dev Button"))),
            ],
          ),
        ),
      ),
    );
  }
}
