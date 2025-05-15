import 'package:flutter/material.dart';

class Riyal extends StatelessWidget {
  const Riyal({
    super.key,
    this.color,
    this.size,
  });
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/riyal.png',
      height: size ?? 20,
      color: color,
    );
  }
}
