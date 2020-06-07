import 'package:flutter/material.dart';
import 'package:targetapp/custom/custom.dart';

import '../fragments/navigation.dart';
import 'package:targetapp/fragments/header.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color background = Color(0xFF401d34);
  final Color textColor = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: "Tableau de bord", showActions: true),
      backgroundColor: this.background,
      body: Padding(
        padding: style["padding"]["view"],
        child: HomePageContent(),
      ),
      bottomNavigationBar: Navigation(index: 0),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Homepage");
  }
}
