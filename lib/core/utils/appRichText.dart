import 'package:flutter/material.dart';

class AppRichText extends StatelessWidget {
  final String title;
  final String value;
  const AppRichText({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: title),
          TextSpan(
            text: value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
