import "package:flutter/material.dart";

class MyTextFieldWidget extends StatefulWidget {
  const MyTextFieldWidget({Key? key, required this.controller, required this.color}) : super(key: key);

  final TextEditingController controller;
  final Color color;

  @override
  State<MyTextFieldWidget> createState() => _MyTextFieldWidgetState();
}

class _MyTextFieldWidgetState extends State<MyTextFieldWidget> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      showCursor: true,
      style: TextStyle(color: widget.color),
      controller: widget.controller,
      cursorColor: widget.color,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.color))
      ),
      textAlign: TextAlign.center,
    );
  }
}
