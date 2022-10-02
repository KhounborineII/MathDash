import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => GamePage(),
        '/b': (BuildContext context) => GameOverPage(),
        '/c': (BuildContext context) => MyHomePage(title: "Math Dash"),
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Dash',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Math Dash!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    void openGame() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GamePage(),
        ),
      );
    }

    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {}

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

    return Scaffold(
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
    );
  }
}

class GameOverPage extends StatefulWidget {
  const GameOverPage({super.key});

  @override
  _GameOverPageState createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  @override
  void initState() {}

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

    return Scaffold(
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
    );
  }
}
