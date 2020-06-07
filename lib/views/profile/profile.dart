import 'package:flutter/material.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/fragments/header.dart';
import 'package:targetapp/fragments/navigation.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/user_model.dart';
import 'package:targetapp/views/profile/forms/edit_profile.dart';
import 'package:targetapp/views/profile/forms/edit_password.dart';

class Profile extends StatefulWidget {
  final int userId;
  const Profile({Key key, this.userId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: "Mon compte", showActions: true),
      backgroundColor: style["colors"]["white"],
      resizeToAvoidBottomPadding: false,
      body: FutureBuilder(
          future: httpService.getUser(widget.userId),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              return ProfileContent(user: snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      bottomNavigationBar: Navigation(index: 3),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final User user;
  const ProfileContent({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: style["padding"]["view"],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Hello",
            style: TextStyle(
                fontSize: style["h1"]["size"],
                fontFamily: style["font"]["Medium"],
                color: style["colors"]["disabled"]),
            textAlign: TextAlign.left,
          ),
          Text(
            this.user.firstname + " " + this.user.lastname,
            style: TextStyle(
                fontSize: style["h1"]["size"],
                fontFamily: style["font"]["SemiBold"],
                color: style["colors"]["primary"]),
            textAlign: TextAlign.left,
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Row(
              children: <Widget>[
                Text(
                  "Nom d'utilisateur : ",
                  style: TextStyle(
                      fontSize: style["p"]["size"],
                      fontFamily: style["font"]["Regular"],
                      color: style["colors"]["black"]),
                  textAlign: TextAlign.left,
                ),
                Text(
                  this.user.username,
                  style: TextStyle(
                      fontSize: style["p"]["size"],
                      fontFamily: style["font"]["Medium"],
                      color: style["colors"]["black"]),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 30),
            child: Row(
              children: <Widget>[
                Text(
                  "Mot de passe : ",
                  style: TextStyle(
                      fontSize: style["p"]["size"],
                      fontFamily: style["font"]["Regular"],
                      color: style["colors"]["black"]),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "**********",
                  style: TextStyle(
                      fontSize: style["p"]["size"],
                      fontFamily: style["font"]["Medium"],
                      color: style["colors"]["black"]),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
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
                showEditProfileModal(context, this.user);
              },
              child: Text('Modifier mon profil',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: style["button"]["size"],
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
                showEditPasswordModal(context, this.user);
              },
              child: Text('Modifier mon mot de passe',
                  style: TextStyle(
                    color: style["colors"]["primary"],
                    fontSize: style["button"]["size"],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
