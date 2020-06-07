import 'package:flutter/material.dart';
import 'package:targetapp/router.dart';

void main() => runApp(new Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TargetDeuzy - Atteignez vos objectifs !',
      theme: ThemeData(fontFamily: 'Quicksand SemiBold'),
      initialRoute: '/signin',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
