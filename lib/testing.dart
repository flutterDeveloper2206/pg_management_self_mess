import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(BubbleStreamMania());
}

class BubbleStreamMania extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int rows = 10;
  static const int cols = 8;
  static const int bubbleTarget = 300;
  static const int levelTime = 120;

  List<List<Color>> grid = [];
  int score = 0;
  int remainingTime = levelTime;
  Timer? gameTimer;
  bool isGameOver = false;
  bool hasWon = false;

  final List<Color> bubbleColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    generateGrid();
    startTimer();
  }

  void generateGrid() {
    final random = Random();
    grid = List.generate(rows, (y) {
      return List.generate(cols, (x) => bubbleColors[random.nextInt(bubbleColors.length)]);
    });
  }

  void startTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime == 0 || score >= bubbleTarget) {
        timer.cancel();
        setState(() {
          isGameOver = true;
          hasWon = score >= bubbleTarget;
        });
        showGameOverDialog();
      } else {
        setState(() => remainingTime--);
      }
    });
  }

  void popBubbles(int row, int col, Color targetColor, Set<String> visited) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) return;
    if (grid[row][col] != targetColor) return;
    final key = '$row,$col';
    if (visited.contains(key)) return;

    visited.add(key);

    popBubbles(row - 1, col, targetColor, visited);
    popBubbles(row + 1, col, targetColor, visited);
    popBubbles(row, col - 1, targetColor, visited);
    popBubbles(row, col + 1, targetColor, visited);
  }

  void handleBubbleTap(int row, int col) {
    if (isGameOver || grid[row][col] == Colors.transparent) return;
    final color = grid[row][col];
    final connected = <String>{};
    popBubbles(row, col, color, connected);

    if (connected.length >= 2) {
      setState(() {
        for (var pos in connected) {
          final parts = pos.split(',');
          final y = int.parse(parts[0]);
          final x = int.parse(parts[1]);
          grid[y][x] = Colors.transparent;
        }
        score += connected.length * 10;
        shiftGridDown();

        if (score >= bubbleTarget) {
          isGameOver = true;
          hasWon = true;
          gameTimer?.cancel();
          showGameOverDialog();
        }
      });
    }
  }

  void shiftGridDown() {
    for (int col = 0; col < cols; col++) {
      int emptyRow = rows - 1;
      for (int row = rows - 1; row >= 0; row--) {
        if (grid[row][col] != Colors.transparent) {
          grid[emptyRow][col] = grid[row][col];
          if (emptyRow != row) {
            grid[row][col] = Colors.transparent;
          }
          emptyRow--;
        }
      }
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(hasWon ? 'You Win!' : 'TimeUp!'),
        content: Text(hasWon ? 'Congratulations! You reached the target score.' : 'Try again to beat the level.'),
        actions: [
          TextButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                score = 0;
                remainingTime = levelTime;
                isGameOver = false;
                hasWon = false;
                generateGrid();
                startTimer();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LEVEL 1',
                style: TextStyle(color: Colors.pinkAccent, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.pause, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                childAspectRatio: 1.0,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: rows * cols,
              itemBuilder: (context, index) {
                final row = index ~/ cols;
                final col = index % cols;
                final color = grid[row][col];

                return GestureDetector(
                  onTap: () => handleBubbleTap(row, col),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        if (color != Colors.transparent)
                          BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ScoreButton(score: score, target: bubbleTarget),
                TimeButton(time: remainingTime),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ScoreButton extends StatelessWidget {
  final int score;
  final int target;
  const ScoreButton({required this.score, required this.target});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.pink, Colors.pinkAccent]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        'SCORE\n$score/$target',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TimeButton extends StatelessWidget {
  final int time;
  const TimeButton({required this.time});

  @override
  Widget build(BuildContext context) {
    final minutes = (time ~/ 60).toString().padLeft(2, '0');
    final seconds = (time % 60).toString().padLeft(2, '0');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.pink, Colors.pinkAccent]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        'TIME\n$minutes:$seconds',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}