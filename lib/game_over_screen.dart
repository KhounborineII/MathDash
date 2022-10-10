import 'package:flutter/material.dart';
import 'package:math_dash/main.dart';

class GameOverPage extends StatefulWidget {
  const GameOverPage({super.key});

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  String winLose = " ";
  int thisPlayerScore = 0;
  int otherPlayerScore = 0;

  @override
  void initState() {
    super.initState();
    winOrLose();
  }

  void winOrLose() {
    if (thisPlayerScore > otherPlayerScore) {
      winLose = "You Win!";
    } else if (thisPlayerScore < otherPlayerScore) {
      winLose = "You Lose!";
    } else {
      winLose = "Its a Tie!";
    }
  }

  @override
  Widget build(BuildContext context) {
    void openHome() {
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
              const Text(
                'Game Over!',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w900,
                    fontSize: 60),
              ),
              const SizedBox(height: 20),
              Text(
                winLose,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w900,
                    fontSize: 50),
              ),
              const SizedBox(height: 40),
              Text(
                'You: $thisPlayerScore',
                style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 30),
              ),
              const SizedBox(height: 20),
              Text(
                'Them: $otherPlayerScore',
                style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 30),
              ),
              const SizedBox(height: 30),
              SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      key: const Key("QuitButton"),
                      onPressed: openHome,
                      style: ElevatedButton.styleFrom(
                          textStyle: (const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500))),
                      child: const Text("Back"))),
            ],
          ),
        ),
      ),
    );
  }
}
