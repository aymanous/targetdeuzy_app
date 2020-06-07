import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/space_model.dart';
import 'package:targetapp/models/user_model.dart';

final _formKey = GlobalKey<FormState>();

class EditProfileForm extends StatefulWidget {
  final User user;
  EditProfileForm({Key key, this.user}) : super(key: key);

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
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
                widget.user.lastname = value;
              });
            },
            initialValue: widget.user.lastname,
            decoration: InputDecoration(
              labelText: "Nom",
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
          TextFormField(
            validator: (String value) {
              return value.length == 0 ? "Champ obligatoire" : null;
            },
            onChanged: (String value) {
              setState(() {
                widget.user.firstname = value;
              });
            },
            initialValue: widget.user.firstname,
            decoration: InputDecoration(
              labelText: "Prénom",
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
          TextFormField(
            validator: (String value) {
              return value.length == 0 ? "Champ obligatoire" : null;
            },
            onChanged: (String value) {
              setState(() {
                widget.user.username = value;
              });
            },
            initialValue: widget.user.username,
            decoration: InputDecoration(
              labelText: "Nom d'utilisateur",
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
                    saveEditProfile(context, widget.user);
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

void showEditProfileModal(context, User user) {
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
                child: EditProfileForm(user: user),
              ),
            ],
          ),
          elevation: 0,
        );
      });
}

void saveEditProfile(context, User user) {
  final HttpService httpService = HttpService();

  httpService.updateUser(user).then((state) => {
        if (state == true)
          {
            Navigator.pop(context),
            Fluttertoast.showToast(
                msg: 'Informations modifiées avec succès !',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 25),
          }
        else
          {throw "Error"}
      });
}
