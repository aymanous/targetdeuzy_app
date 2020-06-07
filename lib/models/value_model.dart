import 'package:flutter/foundation.dart';

class Value {
  String entryId;
  String indicatorId;
  String indicatorName;
  String indicatorType;
  String value;

  Value({
    @required this.entryId,
    @required this.indicatorId,
    @required this.indicatorName,
    @required this.indicatorType,
    @required this.value,
  });

  factory Value.fromJson(Map<String, dynamic> obj) {
    return Value(
      entryId: obj['entryId'] as String,
      indicatorId: obj['indicatorId'] as String,
      indicatorName: obj['indicatorName'] as String,
      indicatorType: obj['indicatorType'] as String,
      value: obj['value'] as String,
    );
  }
}
