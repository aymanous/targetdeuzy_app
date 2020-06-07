import 'package:flutter/material.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/fragments/header.dart';
import 'package:targetapp/views/authentication/signin.dart';
import 'package:targetapp/views/authentication/signup.dart';
import 'package:targetapp/views/entries/forms/new.dart';
import 'package:targetapp/views/entries/list.dart';
import 'package:targetapp/views/entries/single.dart';
import 'package:targetapp/views/profile/profile.dart';
import 'package:targetapp/views/spaces/list.dart';
import 'package:targetapp/views/spaces/single.dart';
import 'package:targetapp/views/charts/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    String view = settings.name;
    int userId;
    getLocalValue("userId").then((value) {
      if (value == null)
        view = '/signin';
      else
        userId = int.parse(value);
    });

    switch (view) {
      // case '/':
      //   return MaterialPageRoute(builder: (_) => HomePage());

      case '/signin':
        return MaterialPageRoute(builder: (_) => Signin());

      case '/signup':
        return MaterialPageRoute(builder: (_) => Signup());

      case '/spacesList':
        return MaterialPageRoute(
            builder: (_) => SpacesList(
                  userId: userId,
                ));

      case '/singleSpace':
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => SingleSpace(
              id: args,
            ),
          );
        }
        return _errorRoute();

      case '/newEntry':
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => NewEntry(
              spaceId: args,
            ),
          );
        }
        return _errorRoute();

      case '/entriesHistory':
        return MaterialPageRoute(
            builder: (_) => EntriesHistory(
                  userId: userId,
                ));

      case '/singleEntry':
        return MaterialPageRoute(builder: (_) => SingleEntry(entry: args));

      case '/chart':
        return MaterialPageRoute(
            builder: (_) => ChartsMain(
                  indicatorId: args,
                ));

      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile(userId: userId));

      case '/error':
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: Header(title: "Erreur :(", showActions: false),
        backgroundColor: style["colors"]["white"],
        body: Center(
          child: Text("Erreur"),
        ),
      );
    });
  }
}
