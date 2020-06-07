import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/fragments/header.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/user_model.dart';

final _formKey = GlobalKey<FormState>();
dynamic form_values = {};

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: "", showActions: false),
      backgroundColor: style["colors"]["white"],
      body: SingleChildScrollView(child: SignupContent()),
      bottomNavigationBar: null,
    );
  }
}

class SignupContent extends StatelessWidget {
  HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: null,
            height: 80,
          ),
          new Image.asset('assets/images/logo-menu.png', width: 150),
          Container(
            child: null,
            height: 20,
          ),
          Container(
            // color: style["colors"]["primary"],
            margin: EdgeInsets.only(top: 25, right: 70, left: 70),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    validator: (String value) {
                      return value.length == 0 ? "Champ obligatoire" : null;
                    },
                    onChanged: (String value) {
                      form_values["lastname"] = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Nom",
                      labelStyle: TextStyle(
                          color: style["colors"]["primary"],
                          fontSize: style["sub"]["size"],
                          fontFamily: style["font"]["SemiBold"]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: style["colors"]["primary"]),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: style["colors"]["gray-1"], width: 1.0)),
                    ),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'AvenirLight'),
                    //  controller: _passwordController,
                  ),
                  TextFormField(
                    validator: (String value) {
                      return value.length == 0 ? "Champ obligatoire" : null;
                    },
                    onChanged: (String value) {
                      form_values["firstname"] = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Prénom",
                      labelStyle: TextStyle(
                          color: style["colors"]["primary"],
                          fontSize: style["sub"]["size"],
                          fontFamily: style["font"]["SemiBold"]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: style["colors"]["primary"]),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: style["colors"]["gray-1"], width: 1.0)),
                    ),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'AvenirLight'),
                    //  controller: _passwordController,
                  ),
                  TextFormField(
                    validator: (String value) {
                      return value.length == 0 ? "Champ obligatoire" : null;
                    },
                    onChanged: (String value) {
                      form_values["username"] = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Nom d'utilisateur",
                      labelStyle: TextStyle(
                          color: style["colors"]["primary"],
                          fontSize: style["sub"]["size"],
                          fontFamily: style["font"]["SemiBold"]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: style["colors"]["primary"]),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: style["colors"]["gray-1"], width: 1.0)),
                    ),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'AvenirLight'),
                    //  controller: _passwordController,
                  ),
                  TextFormField(
                    validator: (String value) {
                      return value.length == 0 ? "Champ obligatoire" : null;
                    },
                    onChanged: (String value) {
                      form_values["password_1"] = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      labelStyle: TextStyle(
                          color: style["colors"]["primary"],
                          fontSize: style["sub"]["size"],
                          fontFamily: style["font"]["SemiBold"]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: style["colors"]["primary"]),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: style["colors"]["gray-1"], width: 1.0)),
                    ),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'AvenirLight'),
                    //  controller: _passwordController,
                  ),
                  TextFormField(
                    validator: (String value) {
                      return value.length == 0 ? "Champ obligatoire" : null;
                    },
                    onChanged: (String value) {
                      form_values["password_2"] = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirmer mot de passe",
                      labelStyle: TextStyle(
                          color: style["colors"]["primary"],
                          fontSize: style["sub"]["size"],
                          fontFamily: style["font"]["SemiBold"]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: style["colors"]["primary"]),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: style["colors"]["gray-1"], width: 1.0)),
                    ),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'AvenirLight'),
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
                            borderRadius: BorderRadius.circular(
                                style["radius"]["button"])),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) return;
                          if (form_values["password_1"] !=
                              form_values["password_2"]) {
                            Fluttertoast.showToast(
                              msg:
                                  'Les mots de passe saisis ne correspondent pas !',
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIosWeb: 25,
                              backgroundColor: style["colors"]["danger"],
                              textColor: style["colors"]["white"],
                            );
                            return;
                          }
                          httpService
                              .signup(
                                  form_values["lastname"],
                                  form_values["firstname"],
                                  form_values["username"],
                                  form_values["password_1"])
                              .then((User user) => {
                                    if (user != null)
                                      {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/signin'),
                                        Fluttertoast.showToast(
                                          msg:
                                              'Votre compte a été créé avec succès. Vous pouvez maintenant vous y connecter',
                                          toastLength: Toast.LENGTH_LONG,
                                          timeInSecForIosWeb: 25,
                                        ),
                                      }
                                    else
                                      {
                                        Fluttertoast.showToast(
                                          msg:
                                              'Erreur lors de la création de votre compte. Merci de réessayer.',
                                          toastLength: Toast.LENGTH_LONG,
                                          timeInSecForIosWeb: 25,
                                          backgroundColor: style["colors"]
                                              ["danger"],
                                          textColor: style["colors"]["white"],
                                        ),
                                      }
                                  });
                        },
                        child: Text('Créer un compte',
                            style: TextStyle(
                              color: style["colors"]["gray"],
                              fontSize: style["button"]["size"],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
