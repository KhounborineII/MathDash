import 'package:flutter/material.dart';
import 'package:math_dash/home_screen.dart';

class GameOverPage extends StatefulWidget {
  const GameOverPage({super.key});

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  @override
  void initState() {
    super.initState();
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
        appBar: AppBar(
          title: const Text('Game Over!'),
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Game Over',
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w900,
                    fontSize: 50),
              ),
              SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      key: const Key("QuitButton"),
                      onPressed: openHome,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 30)),
                      child: const Text("Back"))),
            ],
          ),
        ),
      ),
    );
  }
}
