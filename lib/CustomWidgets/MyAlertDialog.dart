import 'package:flutter/material.dart';

class MyAlertDialogWidget extends StatefulWidget {
  const MyAlertDialogWidget(
      {Key? key,
      required this.title,
      required this.content,
      required this.actions})
      : super(key: key);
  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  State<MyAlertDialogWidget> createState() => _MyAlertDialogWidgetState();
}

class _MyAlertDialogWidgetState extends State<MyAlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 8,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      title: Center(
          child:
              Text(widget.title, style: const TextStyle(color: Colors.white))),
      content: widget.content,
      actions: widget.actions,
    );
  }
}
