import 'package:flutter/material.dart';
import 'package:targetapp/custom/style.dart';

class Navigation extends StatelessWidget {
  final int index;
  const Navigation({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _navigateToScreens(int index) {
      switch (index) {
        case 1:
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed('/spacesList');
          break;

        case 2:
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed('/entriesHistory');
          break;

        case 3:
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed('/profile');
          break;

        default:
        // Navigator.of(context).pushReplacementNamed('/');
      }
    }

    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int index) {
        if (this.index == index) return;
        _navigateToScreens(index);
      },
      type: BottomNavigationBarType.fixed,
      iconSize: 22,
      items: [
        new BottomNavigationBarItem(
            icon: new Image.asset('assets/images/logo-menu.png'),
            title: new Text("", style: TextStyle(fontSize: 0))),
        new BottomNavigationBarItem(
            icon: Icon(Icons.donut_small), title: new Text("Mes espaces")),
        new BottomNavigationBarItem(
            icon: Icon(Icons.history), title: new Text("Historique")),
        new BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), title: new Text("Mon compte")),
      ],
      unselectedItemColor: style["colors"]["disabled"],
      unselectedFontSize: 12.5,
      selectedItemColor: style["colors"]["primary"],
      selectedFontSize: 13,
      backgroundColor: style["colors"]["white"],
      // elevation: 0,
    );
  }
}
