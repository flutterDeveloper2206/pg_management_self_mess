import 'package:flutter/material.dart';

class ResponsiveLayout {
  // Breakpoints
  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMax &&
      MediaQuery.of(context).size.width < tabletMax;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool isCentered;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 800,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isMobile(context)) {
      return child;
    }

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );

    if (isCentered) {
      content = Center(
        heightFactor: 1.0,
        child: content,
      );
    }

    return content;
  }
}
