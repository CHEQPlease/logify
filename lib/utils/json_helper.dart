import 'dart:convert';

class JSON {
  static String tryEncode(dynamic object) {
    try {
      return json.encode(object);
    } catch (e) {
      return object.toString();
    }
  }

  static dynamic tryDecode(String jsonStr) {
    try {
      return json.decode(jsonStr);
    } catch (e) {
      return jsonStr;
    }
  }
}