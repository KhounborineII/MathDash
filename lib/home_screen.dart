import 'package:flutter/material.dart';
import 'package:math_dash/game_screen.dart';

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
          builder: (context) => const GamePage(),
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
              TextField(
                onChanged: (value) {
                  setState(() {});
                },
                decoration: const InputDecoration(hintText: "IP Address"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: 300,
                  height: 100,
                  child: ElevatedButton(
                      key: const Key("PlayButton"),
                      onPressed: openGame,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 30)),
                      child: const Text("Play!"))),
            ],
          ),
        ),
      ),
    );
  }
}
