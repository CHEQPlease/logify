import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/networking/api_helper.dart';

class ApiAdapter implements CloudAdapter {
  final String url;
  final dynamic reqHeader;

  ApiAdapter(this.url, this.reqHeader);

  @override
  Future<bool> syncJob(List<Log> logList) async {
    try {
      await upload(logList);

      return Future.value(true);
    } catch (e) {
      throw ('Sync failed - $e');
    }
  }

  Future<void> upload(List<Log> logList) async {
    try {
      await ApiHelper().post(url, reqHeader, getReqBody(logList));
    } catch (e) {
      rethrow;
    }
  }

  dynamic getReqBody(List<Log> logList) {
    return {
      "streams": logList.map((log) {
        return {
          "stream": {"app": "prod-cheq-pos", "level": log.logLevel},
          "values": [
            [
              '${DateTime.now().millisecondsSinceEpoch.toString().replaceRange(10, 13, '')}000000000',
              {
                "log": {
                  'tag': log.tag,
                  'message': log.message,
                  'log_time': log.logTime,
                  'file_name': log.fileName,
                  'line_number': log.lineNumber,
                  'function_name': log.functionName,
                }
              }
            ]
          ]
        };
      }).toList(),
    };
  }
}