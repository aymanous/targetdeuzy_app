import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/space_model.dart';
import 'package:targetapp/models/user_model.dart';

final _formKey = GlobalKey<FormState>();
dynamic form_values = {};

class EditPasswordForm extends StatefulWidget {
  final User user;
  EditPasswordForm({Key key, this.user}) : super(key: key);

  @override
  _EditPasswordFormState createState() => _EditPasswordFormState();
}

class _EditPasswordFormState extends State<EditPasswordForm> {
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
              print(value);
              setState(() {
                form_values["password_1"] = value;
              });
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Nouveau mot de passe",
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
          ),
          TextFormField(
            validator: (String value) {
              return value.length == 0 ? "Champ obligatoire" : null;
            },
            onChanged: (String value) {
              setState(() {
                form_values["password_2"] = value;
              });
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Confirmer mot de passe",
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
                  // if (!_formKey.currentState.validate()) return;
                  if (form_values["password_1"] != form_values["password_2"]) {
                    Fluttertoast.showToast(
                      msg: 'Les mots de passe saisis ne correspondent pas !',
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 25,
                      backgroundColor: style["colors"]["danger"],
                      textColor: style["colors"]["white"],
                    );
                    return;
                  }
                  saveEditPassword(
                      context, int.parse(widget.user.id), form_values["password_1"]);
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

void showEditPasswordModal(context, User user) {
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
              SingleChildScrollView(
                child: EditPasswordForm(user: user),
              ),
            ],
          ),
          elevation: 0,
        );
      });
}

void saveEditPassword(context, userId, password) {
  final HttpService httpService = HttpService();

  httpService.updateUserPassword(userId, password).then((state) => {
        if (state == true)
          {
            Navigator.pop(context),
            Fluttertoast.showToast(
                msg: 'Mot de passe modifié avec succès !',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 25),
          }
        else
          {throw "Error"}
      });
}
