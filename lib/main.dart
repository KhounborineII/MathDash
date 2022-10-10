import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:math_dash/request_screen.dart';
import 'package:math_dash/respond_screen.dart';
import 'package:math_dash/game_screen.dart';
import 'package:math_dash/game_over_screen.dart';
import 'package:math_dash/communication.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:network_info_plus/network_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Dash',
      theme: ThemeData(
        colorScheme: _customColorScheme,
      ),
      home: const MyHomePage(title: 'Math Dash!'),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => const GamePage(seed: 123),
        '/b': (BuildContext context) => const GameOverPage(),
        '/c': (BuildContext context) => const MyHomePage(title: "Math Dash"),
      },
    );
  }
}

enum Screens {
  homeScreen,
  requestScreen,
  respondScreen,
  gameScreen,
  resultsScreen;

  static Screens currentScreen = homeScreen;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? ourIpAddress = 'Loading...';
  // why is this important? I'm not sure!
  int ourPort = 8888;
  // placeholder
  String opponentIP = "PLACEHOLDER IP TEXT";

  late StreamSubscription<Socket> server_sub;
  late TextEditingController _ipController;

  void initState() {
    super.initState();
    _ipController = TextEditingController();
    getOurIpAddress();
    _setupServer();
  }

  void dispose() {
    server_sub.cancel();
    super.dispose();
  }

  Future<void> getOurIpAddress() async {
    // Thank you https://stackoverflow.com/questions/52411168/how-to-get-device-ip-in-dart-flutter
    String? ip = await NetworkInfo().getWifiIP();
    setState(() {
      ourIpAddress = ip;
    });
  }

  Future<void> _setupServer() async {
    // TODO: setup ONLY when a valid IP address is entered by the user
    try {
      ServerSocket server =
          await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server_sub = server.listen(_listenToSocket); // StreamSubscription<Socket>
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  void _listenToSocket(Socket socket) {
    socket.listen((data) {
      setState(() {
        _handleIncomingMessage(socket.remoteAddress.address, data);
      });
    });
  }

  void _handleIncomingMessage(String ip, Uint8List incomingData) {
    String received = String.fromCharCodes(incomingData);
    print("Received '$received' from '$ip'");
    // https://stackoverflow.com/questions/55292633
    var jsonMessage = json.decode(received);
    Message decodedMessage = Message.fromJson(jsonMessage);
    handleMessage(decodedMessage);
  }

  void handleMessage(Message message) {
    switch (Screens.currentScreen) {
      case Screens.homeScreen:
        if (message.type == MessageType.invite) {
          goToRespondScreen(message.value['host']);
        }
        break;
      case Screens.requestScreen:
        if (message.type == MessageType.rsvp) {
          if (message.value['response'] == false) {
            goToHomeScreen();
          } else {
            goToGameScreen(message.value['seed']);
          }
        }
        break;
      case Screens.respondScreen:
        if (message.type == MessageType.ignore) {
          goToHomeScreen();
        }
        break;
      case Screens.gameScreen:
        if (message.type == MessageType.update) {
          updateScoreboard(message.value['new_score']);
        } else if (message.type == MessageType.end) {
          updateScoreboard(message.value['final_score']);
        }
        break;
      case Screens.resultsScreen:
        if (message.type == MessageType.update) {
          updateResults(message.value['new_score']);
        } else if (message.type == MessageType.end) {
          updateResults(message.value['final_score']);
        }
        break;
    }
  }

  void goToRespondScreen(String hostIp) {
    // TODO: take the user to the respond screen, letting them know who invited them
    Screens.currentScreen = Screens.respondScreen;
  }

  void goToHomeScreen() {
    /* TODO: take the user back to the home screen, canceling any pending actions.
     * This should be passed to ResultsScreen so that it can call this when done.
     */
    Screens.currentScreen = Screens.homeScreen;
  }

  void goToGameScreen(int seed) {
    // TODO: take the user to the game screen, using the seed provided by the invitee
    Screens.currentScreen = Screens.gameScreen;
  }

  void updateScoreboard(int newScore) {
    // TODO: update the scoreboard on the currently active game with the new opponent score
  }

  void updateResults(int finalScore) {
    // TODO: update the score shown on the results screen
  }

  void goToResultsScreen() {
    /* TODO: take the user to the results screen.
     * This should be passed to GameScreen so that it can call this when done.
     */
    Screens.currentScreen = Screens.resultsScreen;
  }

  Future<void> sendInvite(String opponent_IP) async {
    Socket socket = await Socket.connect(opponent_IP, 8888);
    socket.write(Message(1, MessageType.invite, {"host": ourIpAddress}));
    socket.close();
  }

//NOT SURE IF THIS IS THE CORRECT THING TO PUT HERE!
  void openRequest() {
    sendInvite(opponentIP);
    dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RequestPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Text("My IP: ${ourIpAddress!}"),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w400)),
                      child: const Text("Invite"))),
              const SizedBox(height: 10),

              // This block is commented during testing of message sending. Uncomment only if needed.
              //
              // // Button Below will not exist.
              // // Button should be replaced with logic code that
              // // relates to the network when a play request is sent.

              // SizedBox(
              //     width: 200,
              //     height: 75,
              //     child: ElevatedButton(
              //         key: const Key("TempRespondButton"),
              //         onPressed: () {},
              //         style: ElevatedButton.styleFrom(
              //             textStyle: const TextStyle(
              //                 fontSize: 15, fontWeight: FontWeight.w500)),
              //         child: const Text("Respond Dev Button"))),
            ],
          ),
        ),
      ),
    );
  }
}

// Thank you, https://sanjibsinha.com/color-flutter/
const ColorScheme _customColorScheme = ColorScheme(
  primary: Colors.orange,
  secondary: Colors.orange,
  surface: Colors.red,
  background: customSurfaceWhite,
  error: customMagenta900,
  onPrimary: Colors.black,
  onSecondary: Colors.deepOrange,
  onSurface: Colors.white,
  onBackground: customMagenta100,
  onError: Colors.redAccent,
  brightness: Brightness.dark,
);
const Color customMagenta100 = Color(0xfffaac9d);
const Color customMagenta900 = Color(0xfff4310a);
const Color customErrorRed = Color(0xFFC5032B);
const Color customSurfaceWhite = Color(0xFFFFFBFA);
