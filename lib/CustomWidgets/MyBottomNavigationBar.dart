import "package:flutter/material.dart";

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({Key? key, required this.myContext, required this.selectedIndex})  : super(key: key);

  final int selectedIndex;
  final BuildContext myContext;

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        if (selectedIndex != index) {
          Navigator.pushNamed(myContext, '/');
        }
        break;
      case 2:
        if (selectedIndex != index) {
          Navigator.pushNamed(myContext, '/addExpense');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    context = myContext;

    return BottomNavigationBar(
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
          icon: Icon(Icons.people),
          label: 'People',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).backgroundColor,
      onTap: onItemTapped,
    );
  }
}
