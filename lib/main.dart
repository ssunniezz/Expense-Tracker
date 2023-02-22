import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_tracker/ExpenseHistoryScreen.dart';

import 'HomeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class Category {
  Category(this.name);

  String name;

  @override
  String toString() {
    // TODO: implement toString
    return name;
  }
}

List<Category> list = [
  Category("One"),
  Category("Two"),
  Category("Three"),
  Category("Four")
  ];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
        backgroundColor: Colors.lightBlueAccent.shade100.withAlpha(240),
        scaffoldBackgroundColor: Colors.grey.shade800.withAlpha(240),
        bottomAppBarColor: Colors.grey.shade800.withAlpha(240),
        canvasColor: Colors.white.withAlpha(240),
      ),
      home: const HomeScreen(),
    );
  }
}
