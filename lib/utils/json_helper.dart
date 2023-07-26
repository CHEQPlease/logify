import 'dart:convert';

class JSON {
  static String safeEncode(Map<String, dynamic>? object) {
    try {
      return json.encode(object);
    } catch (e) {
      return json.encode({'Logify Error, Invalid JSON input': e.toString()});
    }
  }
}