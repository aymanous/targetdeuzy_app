import 'package:flutter/foundation.dart';
import 'package:targetapp/models/indicator_model.dart';

class Space {
  String id;
  String name;
  String lastEntry;
  String userId;
  List<Indicator> indicators;

  Space(
      {@required this.id,
      @required this.name,
      @required this.lastEntry,
      @required this.userId,
      @required this.indicators});

  factory Space.fromJson(Map<String, dynamic> obj) {
    return Space(
      id: obj['id'] as String,
      name: obj['name'] as String,
      lastEntry: obj['lastEntry'] as String,
      userId: obj['userId'] as String,
    );
  }
}
