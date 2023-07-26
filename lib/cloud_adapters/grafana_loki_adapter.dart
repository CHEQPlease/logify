import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/networking/api_helper.dart';

class GrafanaLokiAdapter implements CloudAdapter {
  final String url;
  final dynamic reqHeader;
  final String env;

  GrafanaLokiAdapter(this.url, this.reqHeader, this.env);

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
          "stream": {"app": env, "level": log.logLevel},
          "values": [
            [
              '${DateTime.now().millisecondsSinceEpoch.toString().replaceRange(10, 13, '')}000000000',
              {
                "log": {
                  'tag': log.tag,
                  'msg': log.message,
                  'req': log.req,
                  'res': log.res,
                  'err': log.err,
                  'props': log.props,
                  'lvl': log.logLevel,
                  'time': log.logTime,
                  'file': log.fileName,
                  'line': log.lineNumber,
                  'func': log.functionName,
                }
              }
            ]
          ]
        };
      }).toList(),
    };
  }
}