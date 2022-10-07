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
    //
    // invite
    // { "host": "host_ip_address" }
    //
    // ignore
    // {}
    //
    // rsvp
    // { "response": true\|false, "seed": 123 }
    //
    // update
    // { "new_score": 123 }
    //
    // end
    // { "final_score": 123 }
    //
    // openRespond();
  }

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
