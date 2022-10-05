import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_dash/game_core.dart';
import 'package:math_dash/game_over_screen.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  // TODO: initialize these values in a constructor or initState call
  int thisPlayerScore = 0;
  int otherPlayerScore = 0;
  bool isGameOver = false;

  late int timeLeft;
  late String currentQuestion;
  late int currentAnswer;

  final questionGenerator = QuestionGenerator(seed: 123);
  final answerInputController = TextEditingController();
  late final Timer timer;
  
  @override
  void initState() {
    super.initState();
    timeLeft = 30;
    timer = Timer.periodic(const Duration(seconds: 1), countdown);
    nextQuestion();
  }

  void nextQuestion() {
    MathProblem newProblem = questionGenerator.nextQuestion();
    // an update message would be sent here
    setState(() {
      currentQuestion = newProblem.question;
      currentAnswer = newProblem.answer;
    });
  }

  void checkAnswer(String value) {
    answerInputController.clear();
    if (int.tryParse(value) == currentAnswer) {
      thisPlayerScore++;
      nextQuestion();
    }
  }

  void countdown(Timer t) {
    if (timeLeft > 0) {
      setState(() {
        timeLeft--;        
      });
    } else {
      // an end message would be sent here
      setState(() {
        isGameOver = true;
      });
      t.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Color defaultBlue = Theme.of(context).primaryColor;
    Color darkBlue = Theme.of(context).primaryColorDark;

    if (isGameOver) {
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row( // Scoreboard/timer at top of screen
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column( // This player's score
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You',
                        style: TextStyle(
                          color: defaultBlue,
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        '$thisPlayerScore',
                        style: TextStyle(
                          color: defaultBlue,
                          fontSize: 40,
                        ),
                        key: const Key('thisPlayerScoreText'),
                      ),
                    ],
                  ),
                  Column( // Timer
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined, 
                        color: defaultBlue,
                        size: 50,
                      ),
                      Text(
                        '$timeLeft',
                        style: TextStyle(
                          color: defaultBlue,
                          fontSize: 40,
                        ),
                        key: const Key('timeLeftText'),
                      ),
                    ],
                  ),
                  Column( // Other player's score
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Them',
                        style: TextStyle(
                          color: defaultBlue,
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        '$otherPlayerScore',
                        style: TextStyle(
                          color: defaultBlue,
                          fontSize: 40,
                        ),
                        key: const Key('otherPlayerScoreText'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 130),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text( // Current math question
                    currentQuestion,
                    style: TextStyle(
                          color: darkBlue,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                    key: const Key('CurrentQuestionText'),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      key: const Key('answerTextField'),
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: answerInputController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      onSubmitted: checkAnswer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
