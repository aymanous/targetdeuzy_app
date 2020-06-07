import 'package:flutter/foundation.dart';

class Entry {
  String id;
  String timestamp;
  String date;
  String spaceId;
  String spaceName;

  Entry({
    @required this.id,
    @required this.timestamp,
    @required this.date,
    @required this.spaceId,
    @required this.spaceName,
  });

  factory Entry.fromJson(Map<String, dynamic> obj) {
    return Entry(
      id: obj['id'] as String,
      timestamp: obj['timestamp'] as String,
      date: obj['date'] as String,
      spaceId: obj['spaceId'] as String,
      spaceName: obj['spaceName'] as String,
    );
  }
}
