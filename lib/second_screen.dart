import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Screen'),),
      body: Column(
        children: [
          Center(child: Text('Second two Screen'),),
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text('Back To Previous Screen'))
        ],
      ),
    );
  }
}
