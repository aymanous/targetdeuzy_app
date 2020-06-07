import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/space_model.dart';

final _formKey = GlobalKey<FormState>();

class EditSpaceForm extends StatefulWidget {
  final Space space;
  EditSpaceForm({Key key, this.space}) : super(key: key);

  @override
  _EditSpaceFormState createState() => _EditSpaceFormState();
}

class _EditSpaceFormState extends State<EditSpaceForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            initialValue: widget.space.name,
            validator: (String value) {
              return value.length == 0 ? "Champ obligatoire" : null;
            },
            onChanged: (String value) {
              setState(() {
                widget.space.name = value;
              });
            },
            decoration: InputDecoration(
              labelText: "Nom de l'espace",
              labelStyle: TextStyle(
                  color: style["colors"]["primary"],
                  fontSize: style["input"]["size"],
                  fontFamily: style["font"]["SemiBold"]),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: style["colors"]["primary"]),
              ),
              enabledBorder: new UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: style["colors"]["gray-1"], width: 1.0)),
            ),
            style: TextStyle(
                color: Colors.black87, fontSize: 17, fontFamily: 'AvenirLight'),
          ),
          Divider(
            color: style["colors"]["white"],
          ),
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            child: RaisedButton(
              padding: style["padding"]["button"],
              color: style["colors"]["primary"],
              shape: new RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(style["radius"]["button"])),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  saveUpdatedSpace(context, widget.space);
                }
              },
              child: Text('Mettre à jour',
                  style: TextStyle(
                    color: style["colors"]["white"],
                    fontSize: style["medium"]["size"],
                  )),
            ),
          ),
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            child: RaisedButton(
              padding: style["padding"]["button"],
              color: style["colors"]["gray"],
              shape: new RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(style["radius"]["button"])),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  deleteSpace(context, widget.space);
                }
              },
              child: Text('Supprimer',
                  style: TextStyle(
                    color: style["colors"]["primary"],
                    fontSize: style["medium"]["size"],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

void showEditSpaceModal(context, spaceId) {
  HttpService httpService = HttpService();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                width: 27,
                right: -35.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close,
                        size: 15, color: style["colors"]["white"]),
                    backgroundColor: style["colors"]["primary"],
                  ),
                ),
              ),
              FutureBuilder(
                  future: httpService.getSpace(spaceId),
                  builder:
                      (BuildContext context, AsyncSnapshot<Space> snapshot) {
                    if (snapshot.hasData) {
                      return EditSpaceForm(space: snapshot.data);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),
          elevation: 0,
        );
      });
}

void saveUpdatedSpace(context, Space space) {
  final HttpService httpService = HttpService();

  httpService.updateSpace(space).then((bool flag) => {
        if (flag == true)
          {
            Navigator.pop(context),
            Navigator.of(context).pushReplacementNamed('/singleSpace',
                arguments: int.parse(space.id)),
            Fluttertoast.showToast(
                msg: 'Espace modifié avec succès !',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 25),
          }
        else
          {throw "Error"}
      });
}

void deleteSpace(context, Space space) {
  final HttpService httpService = HttpService();

  httpService.deleteSpace(space).then((bool flag) => {
        if (flag == true)
          {
            Navigator.pop(context),
            Navigator.of(context).pushReplacementNamed('/spacesList'),
            Fluttertoast.showToast(
                msg: 'Espace supprimé avec succès !',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 25),
          }
        else
          {throw "Error"}
      });
}
