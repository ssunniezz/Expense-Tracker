import 'package:flutter/material.dart';

class MyTextButtonWidget extends StatelessWidget {
  const MyTextButtonWidget({Key? key, required this.color, required this.onPressed, required this.child}) : super(key: key);
  final Color color;
  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          elevation: 8,
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: child);
  }
}
