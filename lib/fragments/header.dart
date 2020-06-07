import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/views/homepage.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showActions;
  final List<Widget> widgets;
  const Header({Key key, this.title, this.showActions, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: style["colors"]["primary"],
      title: Row(
        children: <Widget>[
          Text(this.title,
              style: TextStyle(
                  fontSize: style["h2"]["size"],
                  fontFamily: style["font"]["Regular"],
                  color: style["colors"]["white"]))
        ],
      ),
      actions: <Widget>[
        // if(this.showActions)
        // IconButton(
        //   icon: const Icon(Icons.home, color: const Color(0xFFFFFFFF)),
        //   tooltip: 'Accueil',
        //   onPressed: () {
        //     Navigator.of(context).pushReplacementNamed('/');
        //   },
        // ),
        if (this.showActions)
          IconButton(
            icon: const Icon(Icons.power_settings_new,
                color: const Color(0xFFFFFFFF)),
            tooltip: 'Signout',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signin');
              removeLocalValue("userId");
              Fluttertoast.showToast(
                msg: 'A bientôt !',
                toastLength: Toast.LENGTH_LONG,
              );
            },
          ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(60);
}
