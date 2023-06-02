import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/score_manager.dart';
import 'package:quiz_app/quiz_page.dart';

class FinalPage extends StatelessWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<ScoreManager>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Congrats on finishing the quiz!',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your score is: ${scoreProvider.score}',
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed:(){
                  scoreProvider.resetScore();
                  //goto first page
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: const Text(
                 'Retry',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
