import 'package:flutter_test/flutter_test.dart';
import 'package:math_dash/game_core.dart';

import 'dart:math';

void main() {

  QuestionGenerator game = QuestionGenerator(seed: Random().nextInt(1<<32));

  test('The state of a newly constructed game is correct', () {
    expect(game.questionsAsked, 0, reason: 'no questions have been asked yet');
  });

  test('asking a question increments the number of questions asked', () {
    game.nextQuestion();
    expect(game.questionsAsked, 1, reason: 'one question has been asked');

    for (var i = 0; i < 9; i++) {
      game.nextQuestion();
    }
    expect(game.questionsAsked, 10, reason: 'ten questions have been asked');
  });

  test('questions should not have negative answers', () {
    for (var i = 0; i < 10000; i++) {
      MathProblem problem = game.nextQuestion();
      expect(problem.answer < 0, false, reason: 'answers should be nonnegative');
    }
  });

  test('the generated questions and answers match', () {
    for (var i = 0; i < 10000; i++) {
      MathProblem problem = game.nextQuestion();
      
      List<String> question = problem.question.split(' ');
      switch (question[1]) {
        case '+':
          expect(int.parse(question[0]) + int.parse(question[2]), problem.answer);
          break;
        case '-':
          expect(int.parse(question[0]) - int.parse(question[2]), problem.answer);
          break;
        case '*':
          expect(int.parse(question[0]) * int.parse(question[2]), problem.answer);
          break;
        case '/':
          expect(int.parse(question[0]) / int.parse(question[2]), problem.answer);
          break;
        default:
          expect('+-*/'.contains(question[1]), true, reason: 'operation must be one of: { + - * / }');
      }
    }
  });
}