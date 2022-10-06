import 'package:flutter/material.dart';
import 'package:math_dash/home_screen.dart';
import 'package:math_dash/game_screen.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
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
          title: const Text("Requesting Opponent"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Will be changed when IP and Networking is developed.
            // Widget should no longer be const,
            // and text should contain entered IP Address.
            children: <Widget>[
              const Text(
                'Requesting to Battle Opponent at IP: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              const SizedBox(height: 10),

              // Button below to be replaced
              // Replace button with accept response
              // Accept response should be from other player

              SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      key: const Key("TempButton"),
                      onPressed: openGame,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20)),
                      child: const Text("Dev Play Button"))),
            ],
          ),
        ),
      ),
    );
  }
}
