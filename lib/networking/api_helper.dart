import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logify/networking/api_exception.dart';

class ApiHelper {
  Future<dynamic> post(String url, Map<String, String> requestHeader,
      dynamic requestBody) async {
    var body = json.encode(requestBody);
    dynamic responseJson;
    try {
      final response =
          await http.post(Uri.parse(url), headers: requestHeader, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(0, 'No Internet connection');
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.body;
      case 204: // No Content
      case 302: // Found
        return '';
      case 400:
      case 401:
      case 403:
      case 404:
      case 500:
        throw BadRequestException(
            response.statusCode, response.body.toString());
      default:
        throw FetchDataException(response.statusCode,
            'Network error. StatusCode : ${response.statusCode}');
    }
  }
}
