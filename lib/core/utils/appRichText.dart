import 'package:flutter/material.dart';

class AppRichText extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  const AppRichText({super.key, required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: title,style: TextStyle(color: color)),
          TextSpan(
            text: value,
            style: TextStyle(fontWeight: FontWeight.bold,color: color),
          ),
        ],
      ),
    );
  }
}
