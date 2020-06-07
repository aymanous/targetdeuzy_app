import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/user_model.dart';

final _formKey = GlobalKey<FormState>();
dynamic form_values = {};

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: Header(title: "", showActions: false),
      backgroundColor: style["colors"]["white"],
      body: SingleChildScrollView(child: SigninContent()),
      bottomNavigationBar: null,
    );
  }
}

class SigninContent extends StatelessWidget {
  HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 70),
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
            margin: EdgeInsets.only(top: 15, right: 70, left: 70),
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
                      form_values["password"] = value;
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
                          httpService
                              .signin(form_values["username"],
                                  form_values["password"])
                              .then((User user) => {
                                    if (user != null)
                                      {
                                        setLocalValue("userId", user.id),
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                '/spacesList'),
                                      }
                                    else
                                      {
                                        Fluttertoast.showToast(
                                          msg:
                                              'Identifiant ou mot de passe incorrect ! Merci de réessayer.',
                                          toastLength: Toast.LENGTH_LONG,
                                          timeInSecForIosWeb: 25,
                                          backgroundColor: style["colors"]
                                              ["danger"],
                                          textColor: style["colors"]["white"],
                                        ),
                                      }
                                  });
                        },
                        child: Text('Connexion',
                            style: TextStyle(
                              color: style["colors"]["white"],
                              fontSize: style["button"]["size"],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        padding: style["padding"]["button"],
                        color: style["colors"]["gray"],
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                style["radius"]["button"])),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: Text('Créer un compte',
                            style: TextStyle(
                              color: style["colors"]["primary"],
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
