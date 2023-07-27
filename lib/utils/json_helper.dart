import 'dart:convert';

class JSON {
  static String safeEncode(Map<String, dynamic>? object) {
    try {
      return json.encode(object);
    } catch (e) {
      return json.encode({'Logify Error, Invalid JSON input': e.toString()});
    }
  }

  static String tryEncode(dynamic object) {
    try {
      return json.encode(object);
    } catch (e) {
      return object.toString();
    }
  }

  static String tryDecode(String jsonStr) {
    try {
      return json.decode(jsonStr);
    } catch (e) {
      return jsonStr;
    }
  }
}