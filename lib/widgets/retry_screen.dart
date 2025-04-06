import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';

class RetryScreen extends StatelessWidget {
  final bool isRetry;
  final Widget child;
  final void Function() onPressed;
  const RetryScreen({
    Key? key,
     required this.onPressed, required this.isRetry, required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRetry
        ?Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                  'assets/animation/66708-something-went-wrong.json'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: AppElevatedButton(buttonName: 'Retry', onPressed: onPressed),
              )
            ],
          ),
        ),
      ),
    ):Container(child:child ,);
  }
}
