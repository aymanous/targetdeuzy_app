import 'package:flutter/foundation.dart';

class User {
  String id;
  String username;
  String firstname;
  String lastname;

  User({
    @required this.id,
    @required this.username,
    @required this.firstname,
    @required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> obj) {
    return User(
      id: obj['id'] as String,
      username: obj['username'] as String,
      firstname: obj['firstname'] as String,
      lastname: obj['lastname'] as String,
    );
  }
}