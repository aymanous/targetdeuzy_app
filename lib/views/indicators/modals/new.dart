import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/indicator_model.dart';

final _formKey = GlobalKey<FormState>();
dynamic form_values = {"type": "Texte"};

class NewIndicatorForm extends StatefulWidget {
  final spaceId;
  NewIndicatorForm({Key key, this.spaceId}) : super(key: key);

  @override
  _NewIndicatorFormState createState() => _NewIndicatorFormState();
}

class _NewIndicatorFormState extends State<NewIndicatorForm> {
  List<String> options = ['Texte', 'Numérique', 'Booléen'];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            validator: (String value) {
              return value.length == 0 ? "Champ obligatoire" : null;
            },
            onChanged: (String value) {
              setState(() {
                form_values["name"] = value;
              });
            },
            decoration: InputDecoration(
              labelText: "Nom de l'indicateur",
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
          DropdownButton<String>(
            value: form_values["type"],
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: style["colors"]["primary"]),
            underline: Container(
              height: 1,
              color: style["colors"]["primary"],
            ),
            isExpanded: true,
            onChanged: (String value) {
              setState(() {
                form_values["type"] = value;
              });
            },
            items: this.options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(
                        fontSize: style["input"]["size"],
                        fontFamily: style["font"]["SemiBold"])),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton(
                padding: style["padding"]["button"],
                color: style["colors"]["primary"],
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(style["radius"]["button"])),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    saveNewIndicator(context, widget.spaceId);
                  }
                },
                child: Text('Enregistrer',
                    style: TextStyle(
                      color: style["colors"]["white"],
                      fontSize: style["button"]["size"],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void showNewIndicatorModal(context, spaceId) {
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
              NewIndicatorForm(spaceId: spaceId),
            ],
          ),
          elevation: 0,
        );
      });
}

void saveNewIndicator(context, spaceId) {
  final HttpService httpService = HttpService();

  httpService
      .createIndicator(Indicator(
          name: form_values["name"],
          type: form_values["type"],
          spaceId: spaceId))
      .then((id) => {
            if (id != null)
              {
                Navigator.pop(context),
                Navigator.of(context).pushReplacementNamed('/singleSpace',
                    arguments: int.parse(spaceId)),
                Fluttertoast.showToast(
                    msg:
                        'Nouvel indicateur créé avec succès !',
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 25),
              }
            else
              {throw "Error"}
          });
}
