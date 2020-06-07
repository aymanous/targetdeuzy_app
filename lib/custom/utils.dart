import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String dateFormatting(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date).toString();
}

String dateTimeFormatting(DateTime date) {
  return DateFormat('dd/MM/yyyy à hh:mm:ss').format(date).toString();
}

Future<bool> setLocalValue(key, value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString(key, value);
}

Future<String> getLocalValue(key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(key);
}

Future<String> removeLocalValue(key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.remove(key);
}
