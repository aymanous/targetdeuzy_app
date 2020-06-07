import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/indicator_model.dart';

final _formKey = GlobalKey<FormState>();

class EditIndicatorForm extends StatefulWidget {
  final Indicator indicator;
  EditIndicatorForm({Key key, this.indicator}) : super(key: key);

  @override
  _EditIndicatorFormState createState() => _EditIndicatorFormState();
}

class _EditIndicatorFormState extends State<EditIndicatorForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            initialValue: widget.indicator.name,
            validator: (String value) {
              return value.length == 0 ? "Champ obligatoire" : null;
            },
            onChanged: (String value) {
              setState(() {
                widget.indicator.name = value;
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
                  saveUpdatedIndicator(context, widget.indicator);
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
                  deleteIndicator(context, widget.indicator);
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

void showEditIndicatorModal(context, indicatorId) {
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
                  future: httpService.getIndicator(indicatorId),
                  builder: (BuildContext context,
                      AsyncSnapshot<Indicator> snapshot) {
                    if (snapshot.hasData) {
                      return EditIndicatorForm(indicator: snapshot.data);
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

void saveUpdatedIndicator(context, Indicator indicator) {
  final HttpService httpService = HttpService();

  httpService.updateIndicator(indicator).then((bool flag) => {
        if (flag == true)
          {
            Navigator.pop(context),
            Navigator.of(context).pushReplacementNamed('/singleSpace',
                arguments: int.parse(indicator.spaceId)),
            Fluttertoast.showToast(
                msg: 'Indicateur modifié avec succès !',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 25),
          }
        else
          {throw "Error"}
      });
}

void deleteIndicator(context, Indicator indicator) {
  final HttpService httpService = HttpService();

  httpService.deleteIndicator(indicator).then((bool flag) => {
        if (flag == true)
          {
            Navigator.pop(context),
            Navigator.of(context).pushReplacementNamed('/singleSpace',
                arguments: int.parse(indicator.spaceId)),
            Fluttertoast.showToast(
                msg: 'Indicateur supprimé avec succès !',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 25),
          }
        else
          {throw "Error"}
      });
}
