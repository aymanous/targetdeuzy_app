import 'package:flutter/foundation.dart';

class Indicator {
  String id;
  String name;
  String type;
  String spaceId;

  Indicator({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.spaceId,
  });

  factory Indicator.fromJson(Map<String, dynamic> obj) {
    return Indicator(
      id: obj['id'] as String,
      name: obj['name'] as String,
      type: obj['type'] as String,
      spaceId: obj['spaceId'] as String,
    );
  }
}
