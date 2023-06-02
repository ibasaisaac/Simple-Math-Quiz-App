import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/quiz_page.dart';
import 'package:quiz_app/score_manager.dart';

//gesture detector instead of buttons
//react er moto routes dewa lagbe
//navigator e route name ta. pushreplacementname- so that cannot go back to intro page after quiz starts

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ScoreManager(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
// class ChangeSize with ChangeNotifier, DiagnosticableTreeMixin {
//   double _size = 10;
//
//   double get size => _size;
//
//   void setSize()
//   {
//     _size+=25;
//     notifyListeners();
//   }
//
//
//   /// Makes `Counter` readable inside the devtools by listing all of its properties
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DoubleProperty('count', _size));
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Math Quiz',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
                child: const Text(
                    'Start',
                  style: TextStyle(
                    fontSize: 25
                  ),
                ),
            ),
          ],
        )
      )
    );
  }
}

// void _navigateToNextScreen(BuildContext context) {
//   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => QuizPage()));
// }
