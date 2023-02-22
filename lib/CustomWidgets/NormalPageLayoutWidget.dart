import "package:flutter/material.dart";

class NormalPageLayoutWidget extends StatelessWidget {
  const NormalPageLayoutWidget(
      {Key? key, required this.title, required this.child})
      : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 2,
            child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ))),
        Expanded(
          flex: 8,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              color: Theme.of(context).backgroundColor,
            ),
            child: child,
          ),
        )
      ],
    );
  }
}
