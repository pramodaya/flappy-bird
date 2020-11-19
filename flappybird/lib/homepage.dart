import 'dart:async';

import 'package:flappybird/barriers.dart';
import 'package:flappybird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0.0;
  double time = 0;
  double height = 0;
  double ballRange = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void _showAlert(BuildContext context, String x) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Try Again"),
      onPressed: () {
        Navigator.of(context).pop();
        // startGame();
      },
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          cancelButton,
          continueButton,
        ],
        title: Text("Wifi"),
        content: Text(x),
      ),
    );
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.5 * time * time + 2.8 * time;

      double ballheight = double.parse((height).toStringAsFixed(2));
      double bar1 = double.parse((barrierXone).toStringAsFixed(1));
      double bar2 = double.parse((barrierXtwo).toStringAsFixed(1));

      print('ballheight: ' + ballheight.toString() + '\n');
      // print('barrierxone: ' + barrierXone.toString() + '\n');
      // print('barrierxtwo: ' + barrierXtwo.toString() + '\n');

      print('bar1: ' + bar1.toString() + '\n');
      print('bar2: ' + bar2.toString() + '\n');

      //for bar1
      if (-0.1 <= bar1 && bar1 <= 0.1) {
        if (ballheight < -0.5 && ballheight < -1.0) {
          print('game over by bar 1');
          _showAlert(context, 'small bar');

          gameHasStarted = false;
          timer.cancel();
        }
      }
      if (-0.1 <= bar2 && bar2 <= 0.1) {
        if (ballheight < 0.00 && ballheight < 1.0) {
          print('game over by bar 2');
          _showAlert(context, 'high bar');
          gameHasStarted = false;
          timer.cancel();
        }
      }

      setState(() {
        birdYaxis = initialHeight - height;
        barrierXone -= 0.01;
        barrierXtwo -= 0.01;
      });

      setState(() {
        if (barrierXone < -1.1) {
          barrierXone += 3.0;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -1.1) {
          barrierXtwo += 3.0;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      if (birdYaxis > 1) {
        gameHasStarted = false;
        _showAlert(context, 'ball down');
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (gameHasStarted) {
                      jump();
                    } else {
                      startGame();
                    }
                  },
                  child: AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 2),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                ),
                Container(
                  alignment: Alignment(0, -0.3),
                  child: gameHasStarted
                      ? Text('')
                      : Text(
                          'T A P  T O  P L A Y',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),

                AnimatedContainer(
                  alignment: Alignment(barrierXone, 1.1),
                  duration: Duration(microseconds: 0),
                  child: MyBarrier(
                    size: 0.2,
                  ),
                ),
                // AnimatedContainer(
                //   alignment: Alignment(barrierXone, -1.1),
                //   duration: Duration(microseconds: 0),
                //   child: MyBarrier(
                //     size: 100.0,
                //   ),
                // ),
                AnimatedContainer(
                  alignment: Alignment(barrierXtwo, 1.1),
                  duration: Duration(microseconds: 0),
                  child: MyBarrier(
                    size: 0.4,
                  ),
                ),
                // AnimatedContainer(
                //   alignment: Alignment(barrierXtwo, -1.1),
                //   duration: Duration(microseconds: 0),
                //   child: MyBarrier(
                //     size: 70.0,
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '0',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Best',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '10',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
