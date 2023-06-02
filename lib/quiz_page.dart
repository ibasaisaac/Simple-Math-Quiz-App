import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/final_page.dart';
import 'package:quiz_app/score_manager.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _num1 = 0;
  int _num2 = 0;
  String _operator = '+';
  double _correctAnswer = 0;
  bool _isAnswered = false;
  late Timer _globalTimer;
  late Timer _timer;
  late int _timerCountdown;
  late int _globalTimerCountdown;
  int totalTime = 60;
  String? _userAnswer;
  int life = 3;
  bool enableQuestion = true;

  List<String> _operators = ['+', '-', '×', '÷'];
  List<String> _options = [];


  @override
  void initState() {
    super.initState();
    _generateQuestion();
    _timerCountdown = 10;
    _globalTimerCountdown = 60;
    startTimer();
    startGlobalTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _globalTimer.cancel();
    super.dispose();
  }

  void _generateQuestion() {
    _currentIndex++;
    final random = Random();
    _num1 = random.nextInt(10);
    _num2 = random.nextInt(10);
    _operator = _operators[random.nextInt(_operators.length)];

    _correctAnswer = _calculateAnswer();

    double a = _generateRandomAnswer(_correctAnswer);
    double b = _generateRandomAnswer(_correctAnswer);
    while(b==a){
      b = _generateRandomAnswer(_correctAnswer);
    }
    //b == a ? b = _generateRandomAnswer(_correctAnswer) : b;
    double c = _generateRandomAnswer(_correctAnswer);
    while(c==b || c==a){
      c = _generateRandomAnswer(_correctAnswer);
    }
    //c == a || c == b ? c = _generateRandomAnswer(_correctAnswer) : c;

    _options = [
      _correctAnswer.toString(),
      a.toString(),
      b.toString(),
      c.toString(),
    ];

    _options.shuffle();
  }

  double _generateRandomAnswer(double _answer) {
    double _min = _answer - 50;
    double _max = _answer + 50;
    final random = Random();
    double randomNumber = _min + (_max - _min) * random.nextDouble();
    String n = randomNumber.toStringAsFixed(2);
    randomNumber = double.parse(n);
    return randomNumber;
  }

  double _calculateAnswer() {
    double _result = 0.0;
    switch (_operator) {
      case '+':
        return _result = (_num1 + _num2).toDouble();
      case '-':
        return _result = (_num1 - _num2).toDouble();
      case '×':
        return _result = (_num1 * _num2).toDouble();
      case '÷':
        if(_num2 == 0) _num2 = 1;
        _result = (_num1 / _num2).toDouble();
        String r = _result.toStringAsFixed(2);
        _result = double.parse(r);
        return _result;
      default:
        return 0.0;
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerCountdown > 0) {
          _timerCountdown--;
        } else {
          life--;
          if(life == 0){
            _globalTimer.cancel();
            //navigate to result
            navigateToFinalPage();
          }
          resetTimer();
        }
      });
    });
  }

  void startGlobalTimer() {
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_globalTimerCountdown > 0) {
          _globalTimerCountdown--;
        } else {
          _globalTimer.cancel();
          // Navigate to the result page
          navigateToFinalPage();
        }
      });
    });
  }

  void resetTimer() {
    setState(() {
      enableQuestion = true;
      if(enableQuestion) {
        print('in');
        _generateQuestion();
      }
    });
    _timerCountdown = 10;
  }

  void pauseTimer() {
    _globalTimer?.cancel();
    setState(() {
      enableQuestion = false;
    });
    if(!enableQuestion)
      print('f');
  }

  void _checkAnswer(double answer) {
    final scoreProvider = Provider.of<ScoreManager>(context,listen: false);
    print(_correctAnswer);
    if (answer == _correctAnswer) {
      correctAnswerDialog();
      print('ok');
      scoreProvider.incrementScore();
      // _score++;
    }
    else {
      wrongAnswerDialog(_correctAnswer);
      print('not ok');
      life--;
    }

    if(life == 0){
        _globalTimer.cancel();
        //navigate to result
        navigateToFinalPage();
      }
  }

  void wrongAnswerDialog(double ans){
    pauseTimer();
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Wrong Answer'),
        content: Text('The correct answer is: $ans'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: (){
              Navigator.of(context).pop();
              startGlobalTimer();
              resetTimer();
            },
          ),
        ],
      );
    }
    );
  }


  void correctAnswerDialog(){
    pauseTimer();
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Good job!'),
        content: Text('You got the answer'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: (){
              Navigator.of(context).pop();
              startGlobalTimer();
              resetTimer();
            },
          ),
        ],
      );
    });
  }

  void navigateToFinalPage(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FinalPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: FAProgressBar(
                currentValue: _globalTimerCountdown.toDouble(),
                maxValue: totalTime.toDouble(),
                progressColor: Colors.purple,
                backgroundColor: Colors.grey,
              ),
            ),
            // LinearProgressIndicator(
            //   value: _globalTimerCountdown/totalTime,
            //   minHeight: 30,
            // ),
            SizedBox(height: 20,),
            Text(
              'Question ${_currentIndex}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'What is $_num1 $_operator $_num2?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Remaining Life: $life',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Time remaining: $_timerCountdown seconds',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _options.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  title: Text(_options[index]),
                  value: _options[index],
                  groupValue: _userAnswer,
                  onChanged: (value) {
                    setState(() {
                      _userAnswer = value.toString();
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: const Text(
                  'Submit',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              onPressed: () {
                if(_userAnswer == null) {
                    _checkAnswer(-10000);
                }
                else {
                  _checkAnswer(double.parse(_userAnswer!));
                  print(_userAnswer);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
