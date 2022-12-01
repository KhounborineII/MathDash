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
    );
  }
}

enum Screens {
  homeScreen,
  requestScreen,
  respondScreen,
  gameScreen,
  resultsScreen;

  static List<Screens> screenStack = [homeScreen];
  static Screens get currentScreen => screenStack.last;
  static set currentScreen(Screens newScreen) => screenStack.add(newScreen);

  static void goToHomeScreen(BuildContext context) {
    while (screenStack[screenStack.length - 1] != homeScreen) {
      Navigator.of(context).pop(context);
      screenStack.removeLast();
    }
    print('after going home, screenStack is now $screenStack');
  }

  static void goToRequestScreen(BuildContext context, String invitee) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RequestPage(invitee: invitee),
      ),
    );
    currentScreen = requestScreen;
    print('after going to request screen, screenStack is now $screenStack');
  }

  static void goToRespondScreen(BuildContext context, String hostIp) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RespondPage(host: hostIp),
      ),
    );
    currentScreen = respondScreen;
  }

  static void goToGameScreen(BuildContext context, int seed) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamePage(seed: seed),
      ),
    );
    currentScreen = gameScreen;
  }

  static void updateScoreboard(int newScore) {
    // TODO: update the scoreboard on the currently active game with the new opponent score
  }

  static void updateResults(int finalScore) {
    // TODO: update the score shown on the results screen
  }

  static void goToResultsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GameOverPage(),
      ),
    );
    currentScreen = resultsScreen;
  }
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
  dynamic opponentIpAddress;

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
    try {
      assert(message.version == 2); // Current message protocol version is 2
    } on AssertionError {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            """You're communicating with someone with an incompatible version of 
          Math Dash (version ${message.version}). Please make sure both of you 
          are using the latest version."""),
      ));
      return;
    }

    switch (Screens.currentScreen) {
      case Screens.homeScreen:
        if (message.type == MessageType.invite) {
          print("received an invite from '${message.value['host']}'");
          Screens.goToRespondScreen(context, message.value['host']);
        }
        break;
      case Screens.requestScreen:
        print('received a message while on the request screen');
        if (message.type == MessageType.rsvp) {
          print('received an rsvp');
          if (message.value['response'] == false) {
            print("received a rejection rsvp");
            Screens.goToHomeScreen(context);
          } else {
            print(
                "received an acceptance rsvp with seed ${message.value['seed']}");
            Screens.goToGameScreen(context, message.value['seed']);
          }
        }
        break;
      case Screens.respondScreen:
        if (message.type == MessageType.ignore) {
          print("received an ignore; returning to home page");
          Screens.goToHomeScreen(context);
        }
        break;
      case Screens.gameScreen:
        if (message.type == MessageType.update) {
          Screens.updateScoreboard(message.value['new_score']);
        } else if (message.type == MessageType.end) {
          Screens.updateScoreboard(message.value['final_score']);
        }
        break;
      case Screens.resultsScreen:
        if (message.type == MessageType.update) {
          Screens.updateResults(message.value['new_score']);
        } else if (message.type == MessageType.end) {
          Screens.updateResults(message.value['final_score']);
        }
        break;
    }
  }

  void invitePlayer() async {
    String inviteIp = _ipController.text;
    Socket socket = await Socket.connect(inviteIp, ourPort);
    Message message = Message(2, MessageType.invite, {'host': ourIpAddress});
    var jsonMessage = message.toJson();
    String stringMessage = json.encode(jsonMessage);
    print("sending invite: '$stringMessage'");
    socket.write(stringMessage);
    socket.close();
  }

  @override
  Widget build(BuildContext context) {
    void clickInvite() {
      print('clicked invite button');
      invitePlayer();
      Screens.goToRequestScreen(context, _ipController.text);
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
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "Enter your friend's IP Address!",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300)),
                  controller: _ipController,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: 250,
                  height: 75,
                  child: ElevatedButton(
                      key: const Key("InviteButton"),
                      onPressed: clickInvite,
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic)),
                      child: const Text("Invite!"))),
              const SizedBox(height: 20),
              Text("My IP: ${ourIpAddress!}")

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
