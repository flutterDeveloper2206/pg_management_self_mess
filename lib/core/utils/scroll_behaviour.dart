import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class NoGlowScrollPhysics extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child,  ScrollableDetails axisDirection) {
    return child;
  }
}

class MyCustomScrollBehaviour extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    // etc.
  };
}