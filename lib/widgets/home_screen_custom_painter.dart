import 'package:flutter/material.dart';

class CurveDraw extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double sw = size.width;
    double sh = size.height;
    print(sh);
    Path path = Path();
    path.moveTo(0, sh);
    path.lineTo(0, sh / 2);
    path.quadraticBezierTo(0, 0,0, 0); //1st curve
    path.lineTo(sw / 2 - sw / 5, 0);
    path.cubicTo(sw / 2 - sw / 8, 0, sw / 2 - sw / 8, sh / 2, sw / 2, sh / 2);
    path.cubicTo(
        sw / 2 + sw / 8, sh / 2, sw / 2 + sw / 8, 0, sw / 2 + sw / 5, 0);

    path.lineTo(sw - sh / 2, 0);
    path.quadraticBezierTo(sw, 0, size.width, 0);
    path.lineTo(sw, sh);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
