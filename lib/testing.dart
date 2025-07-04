import 'package:flutter/material.dart';
import 'package:pg_managment/second_screen.dart';

void main() {
  runApp(ClassOne());
}

class ClassOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
            leading: Icon(Icons.arrow_back_ios), title: Text('Tanvi demo')),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Text('Strawberry',
                                style: TextStyle(fontSize: 20)),
                          )),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Text(
                            'Strawberry Strawberry'
                            ' strawberry strawberry strawberry strawberry ',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child:
                            Text('Strawberry', style: TextStyle(fontSize: 20)),
                      )
                    ],
                  ),
                ),
                Expanded(child: Image.asset('assets/icons/images.png'))
              ],
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen(),));
            }, child: Text('Go To Next Page'))
          ],
        ));
  }
}
