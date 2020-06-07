import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/space_model.dart';

final _formKey = GlobalKey<FormState>();
dynamic form_values = {};

class NewSpaceForm extends StatefulWidget {
  final int userId;
  NewSpaceForm({Key key, this.userId}) : super(key: key);

  @override
  _NewSpaceFormState createState() => _NewSpaceFormState();
}

class _NewSpaceFormState extends State<NewSpaceForm> {
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
              labelText: "Nom de l'espace",
              labelStyle: TextStyle(
                  color: style["colors"]["primary"],
                  fontSize: style["sub"]["size"],
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
            //  controller: _passwordController,
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
                    saveNewSpace(context, widget.userId);
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

void showNewSpaceModal(context, int userId) {
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
              NewSpaceForm(userId: userId),
            ],
          ),
          elevation: 0,
        );
      });
}

void saveNewSpace(context, int userId) {
  final HttpService httpService = HttpService();

  httpService
      .createSpace(Space(name: form_values["name"], userId: userId.toString()))
      .then((id) => {
            if (id != null)
              {
                Navigator.pop(context),
                Navigator.of(context).pushNamed('/singleSpace', arguments: id),
                Fluttertoast.showToast(
                    msg:
                        'Nouvel espace créé avec succès ! Crées-y vite un premier indicateur.',
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 25),
              }
            else
              {throw "Error"}
          });
}
