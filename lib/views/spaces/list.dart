import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/fragments/navigation.dart';
import 'package:targetapp/fragments/header.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/space_model.dart';
import 'package:targetapp/views/spaces/modals/new.dart';

class SpacesList extends StatefulWidget {
  final int userId;
  const SpacesList({Key key, this.userId}) : super(key: key);

  @override
  _SpacesListState createState() => _SpacesListState();
}

class _SpacesListState extends State<SpacesList> {
  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    return Scaffold(
      appBar: Header(title: "Mes espaces", showActions: true),
      resizeToAvoidBottomPadding: false,
      backgroundColor: style["colors"]["white"],
      body: Padding(
        padding: style["padding"]["view"],
        child: FutureBuilder(
          future: httpService.getSpaces(widget.userId),
          builder: (BuildContext context, AsyncSnapshot<List<Space>> snapshot) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return SpacesListElements(
                  spaces: snapshot.data, userId: widget.userId);
            } else {
              return NoSpaceAvailabe(userId: widget.userId);
            }
          },
        ),
      ),
      bottomNavigationBar: Navigation(index: 1),
    );
  }
}

class SpacesListElements extends StatelessWidget {
  final List<Space> spaces;
  final int userId;
  const SpacesListElements({Key key, this.spaces, this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Expanded(
            child: ListView.separated(
                separatorBuilder: (_, int i) => Divider(
                      color: style["colors"]["gray-1"],
                    ),
                itemCount: this.spaces.length,
                itemBuilder: (_, int i) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: new Text(this.spaces[i].name,
                        style: TextStyle(
                            fontSize: style["h3"]["size"],
                            fontFamily: style["font"]["Medium"],
                            color: style["colors"]["primary"])),
                    subtitle: new Text(
                        "Dernière saisie : " +
                            (this.spaces[i].lastEntry == null
                                ? "Jamais"
                                : dateFormatting(DateTime.parse(this.spaces[i].lastEntry))),
                        style: TextStyle(
                            fontSize: style["sub"]["size"],
                            fontFamily: style["font"]["Regular"],
                            color: style["colors"]["disabled"])),
                    trailing: new IconButton(
                        icon: new Icon(
                          Icons.keyboard_arrow_right,
                          color: style["colors"]["primary"],
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/singleSpace',
                              arguments: int.parse(this.spaces[i].id));
                        }),
                    onTap: () {
                      Navigator.of(context).pushNamed('/singleSpace',
                          arguments: int.parse(this.spaces[i].id));
                    },
                  );
                })),
        ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          child: RaisedButton(
            padding: style["padding"]["button"],
            color: style["colors"]["primary"],
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(style["radius"]["button"])),
            onPressed: () {
              showNewSpaceModal(context, this.userId);
            },
            child: Text('Créer un nouvel espace',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: style["button"]["size"],
                )),
          ),
        ),
      ],
    );
  }
}

class NoSpaceAvailabe extends StatelessWidget {
  final int userId;
  const NoSpaceAvailabe({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text("Tout nouveau par ici ?",
          style: TextStyle(
              fontSize: style["h1"]["size"],
              fontFamily: style["font"]["Regular"],
              color: style["colors"]["primary"])),
      Text("Crée vite ton premier espace !",
          style: TextStyle(
              fontSize: style["h4"]["size"],
              fontFamily: style["font"]["Light"],
              color: const Color(0xFF555555))),
      Padding(
          padding: EdgeInsets.only(top: 25, right: 50, bottom: 0, left: 50),
          child: Image.asset("assets/images/empty-cart.gif")),
      const SizedBox(height: 30),
      RaisedButton(
        color: style["colors"]["primary"],
        onPressed: () {
          showNewSpaceModal(context, this.userId);
        },
        child: Text('Créer mon premier espace',
            style: TextStyle(fontSize: 18, color: style["colors"]["white"])),
      ),
    ]);
  }
}
