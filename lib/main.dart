import 'package:flutter/material.dart';
import 'package:math_dash/home_screen.dart';
import 'package:math_dash/game_screen.dart';
import 'package:math_dash/game_over_screen.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:network_info_plus/network_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum AppPage {
  homeScreen,
  requestScreen,
  respondScreen,
  gameScreen,
  gameOverScreen
}

class _MyAppState extends State<MyApp> {
  // why is this important? I'm not sure!
  int ourPort = 8888;

  // placeholder
  int opponent_IP = 123;

  //

  String? _ipAddress = "";
  late StreamSubscription<Socket> server_sub;
  late TextEditingController _ipController;

  void initState() {
    super.initState();
    //_nameController = TextEditingController();
    _ipController = TextEditingController();
    _setupServer();
    _findIPAddress();
  }

  void dispose() {
    server_sub.cancel();
    super.dispose();
  }

  Future<void> _findIPAddress() async {
    // Thank you https://stackoverflow.com/questions/52411168/how-to-get-device-ip-in-dart-flutter
    String? ip = await NetworkInfo().getWifiIP();
    setState(() {
      _ipAddress = ip;
    });
  }

  Future<void> sendRequest() async {
    //get opponent ip from text input

    Socket socket = await Socket.connect(opponent_IP, ourPort);
    // "invite"	{ "host": "host_ip_address" }
    socket.write("invite");

    //might not want to close
    socket.close();
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
    //
    //
    // would hear invite
    if (AppPage == "homeScreen") {
      // invite
      // { "host": "host_ip_address" }

      //takes you to response screen

      // would hear rsvp
    } else if (AppPage == "requestScreen" || AppPage == "respondScreen") {
      // rsvp
      // { "response": true\|false, "seed": 123 }

      // if ignore, both go back to home_screen
      // if response is true, both go to game_screen

      //would hear updates and end
    } else if (AppPage == "gameScreen") {
      // update
      // { "new_score": 123 }

      // end
      // { "final_score": 123 }

      //no messages
    } else if (AppPage == "gameOverScreen") {
      // nothing happens?
    } else {
      print("something has gone terribly wrong with communications");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Dash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
