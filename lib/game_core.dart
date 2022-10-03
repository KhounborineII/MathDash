import 'dart:math';

class OpPair {
  OpPair(this.opString, this.opFunc, this.isCommutative);
  final String opString;
  final int Function(int, int) opFunc;
  final bool isCommutative;
}

class MathProblem {
  MathProblem(this.question, this.answer);
  final String question;
  final int answer;
}

class QuestionGenerator {
  
  QuestionGenerator({required int seed}) {
    _rand = Random(seed);
    _questionsAsked = 0;
  }

  final _operations = <OpPair>[
    OpPair('+', (a, b) => a + b, true),
    OpPair('-', (a, b) => a - b, false),
    OpPair('*', (a, b) => a * b, true),
    OpPair('/', (a, b) => a ~/ b, false),
  ];
  late final Random _rand;

  late int _questionsAsked;

  int get questionsAsked => _questionsAsked;

  MathProblem nextQuestion()  {
    _questionsAsked++;
    
    int choice = _rand.nextInt(_operations.length);
    int firstNum = _rand.nextInt(25) + 1; // numbers in the range 1..25
    int secondNum = _rand.nextInt(25) + 1;

    OpPair chosenOp = _operations[choice];

    if (!chosenOp.isCommutative && firstNum < secondNum) { // ensure firstNum > secondNum for non-commutative operations
      int tmp = firstNum;
      firstNum = secondNum;
      secondNum = tmp;
    }
    if (chosenOp.opString == '/') { // ensure firstNum / secondNum is an integer value
      firstNum -= firstNum % secondNum;
    }

    return MathProblem(
      '$firstNum ${chosenOp.opString} $secondNum = ', 
      chosenOp.opFunc(firstNum, secondNum)
    );
  }

}