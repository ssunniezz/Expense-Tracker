import "package:flutter/material.dart";
import 'package:money_tracker/PageWidgets/AddExpenseWidget.dart';
import 'package:money_tracker/PageWidgets/CategoryListWidget.dart';
import 'package:money_tracker/PageWidgets/ExpenseSummaryWidget.dart';
import 'package:money_tracker/PageWidgets/HomeWidget.dart';

import 'PageWidgets/SettingWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget body = const HomeWidget();
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        if (_selectedIndex != index) {
          body = const HomeWidget();
        }
        break;
      case 1:
        if (_selectedIndex != index) {
          body = const ExpenseSummaryWidget();
        }
        break;
      case 2:
        if (_selectedIndex != index) {
          body = AddExpenseWidget();
        }
        break;
      case 3:
        if (_selectedIndex != index) {
          body = const CategoryListWidget();
        }
        break;
      case 4:
        if (_selectedIndex != index) {
          body = const SettingWidget();
        }
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: body,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).backgroundColor,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
