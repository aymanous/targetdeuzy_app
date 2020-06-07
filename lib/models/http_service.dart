import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:targetapp/models/entry_model.dart';
import 'package:targetapp/models/indicator_model.dart';
import 'package:targetapp/models/user_model.dart';
import 'package:targetapp/models/value_model.dart';

import 'space_model.dart';

class HttpService {
  final String baseURI = "http://54.36.99.55/ECL/MOB/API";

  Future<List<Space>> getSpaces(int userId) async {
    final action = "getSpaces" + "&userId=" + userId.toString();

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Space> spaces =
          body.map((dynamic item) => Space.fromJson(item)).toList();
      return spaces;
    } else {
      return [];
    }
  }

  Future<Space> getSpace(int id) async {
    final action = "getSpace&id=" + id.toString();

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      Space space = Space.fromJson(body);
      return space;
    } else {
      return null;
    }
  }

  Future<int> createSpace(Space space) async {
    final action = "createSpace&name=" + space.name + "&userId=" + space.userId;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      int id = int.parse(body);
      return id;
    } else {
      throw 'Error';
    }
  }

  Future<bool> updateSpace(Space space) async {
    final action = "updateSpace" + "&id=" + space.id + "&name=" + space.name;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteSpace(Space space) async {
    final action = "deleteSpace" + "&id=" + space.id;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Indicator>> getIndicators(int spaceId) async {
    final action = "getIndicators" + "&spaceId=" + spaceId.toString();

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Indicator> indicators =
          body.map((dynamic item) => Indicator.fromJson(item)).toList();
      return indicators;
    } else {
      throw 'Error';
    }
  }

  Future<Indicator> getIndicator(int id) async {
    final action = "getIndicator" + "&id=" + id.toString();

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      Indicator indicator = Indicator.fromJson(body);
      return indicator;
    } else {
      throw 'Error';
    }
  }

  Future<int> createIndicator(Indicator indicator) async {
    final action = "createIndicator" +
        "&name=" +
        indicator.name +
        "&type=" +
        indicator.type +
        "&spaceId=" +
        indicator.spaceId;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      int id = int.parse(body);
      return id;
    } else {
      throw 'Error';
    }
  }

  Future<bool> updateIndicator(Indicator indicator) async {
    final action =
        "updateIndicator" + "&id=" + indicator.id + "&name=" + indicator.name;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteIndicator(Indicator indicator) async {
    final action = "deleteIndicator" + "&id=" + indicator.id;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> newEntry(String spaceId, String date, dynamic indicators) async {
    final action = "newEntry" + "&spaceId=" + spaceId + "&date=" + date;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      int entryId = int.parse(body);

      for (var i = 0; i < indicators.length; i++) {
        this.newEntryValue(
            entryId.toString(), indicators[i]["id"], indicators[i]["value"]);
      }
      return entryId;
    } else {
      throw 'Error';
    }
  }

  Future<int> newEntryValue(
      String entryId, String indicatorId, String value) async {
    final action = "newEntryValue" +
        "&entryId=" +
        entryId +
        "&indicatorId=" +
        indicatorId +
        "&value=" +
        value;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      int id = int.parse(body);
      return id;
    } else {
      throw 'Error';
    }
  }

  Future<User> signin(String username, String password) async {
    final action = "signin" + "&username=" + username + "&password=" + password;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      User user = body != -1 ? User.fromJson(body) : null;
      return user;
    } else {
      throw 'Error';
    }
  }

  Future<User> signup(String lastname, String firstname, String username,
      String password) async {
    final action = "signup" +
        "&lastname=" +
        lastname +
        "&firstname=" +
        firstname +
        "&username=" +
        username +
        "&password=" +
        password;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      User user = body != -1 ? User.fromJson(body) : null;
      return user;
    } else {
      throw 'Error';
    }
  }

  Future<User> getUser(int id) async {
    final action = "getUser" + "&id=" + id.toString();

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      User user = body != -1 ? User.fromJson(body) : null;
      return user;
    } else {
      throw 'Error';
    }
  }

  Future<bool> updateUser(User user) async {
    final action = "updateUser" +
        "&id=" +
        user.id +
        "&lastname=" +
        user.lastname +
        "&firstname=" +
        user.firstname +
        "&username=" +
        user.username;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      return body;
    } else {
      throw 'Error';
    }
  }

  Future<bool> updateUserPassword(int userId, String password) async {
    final action = "updateUserPassword" +
        "&id=" +
        userId.toString() +
        "&password=" +
        password;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      return body;
    } else {
      throw 'Error';
    }
  }

  Future<List<dynamic>> getIndicatorEntryOccurences(int indicatorId) async {
    final action = "getIndicatorEntryOccurences" +
        "&indicatorId=" +
        indicatorId.toString();

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      return body;
    } else {
      throw 'Error';
    }
  }

  Future<List<dynamic>> getNumericIndicatorEntryOccurences(
      int indicatorId) async {
    final action = "getNumericIndicatorEntryOccurences" +
        "&indicatorId=" +
        indicatorId.toString();

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      return body;
    } else {
      throw 'Error';
    }
  }

  Future<List<Entry>> getUserEntriesByDate(int userId, String date) async {
    final action = "getUserEntriesByDate" +
        "&userId=" +
        userId.toString() +
        "&date=" +
        date;

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Entry> entries =
          body.map((dynamic item) => Entry.fromJson(item)).toList();
      return entries;
    } else {
      throw 'Error';
    }
  }

  Future<List<Value>> getEntryIndicatorsValues(int entryId) async {
    final action =
        "getEntryIndicatorsValues" + "&entryId=" + entryId.toString();

    http.Response res =
        await http.get(Uri.encodeFull(this.baseURI + "?action=" + action));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Value> values =
          body.map((dynamic item) => Value.fromJson(item)).toList();
      return values;
    } else {
      throw 'Error';
    }
  }
}
