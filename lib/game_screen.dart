import 'package:flutter/material.dart';
import 'package:math_dash/game_over_screen.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void openGameOver() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GameOverPage(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Math Dash!'),
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Put Game Here",
                style: TextStyle(
                    color: Colors.orange,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      key: const Key("QuitButton"),
                      onPressed: openGameOver,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20)),
                      child: const Text("Replace With Timer"))),
            ],
          ),
        ),
      ),
    );
  }
}
