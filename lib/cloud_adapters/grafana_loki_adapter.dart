import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/networking/api_helper.dart';
import 'package:logify/utils/exception_handler.dart';

class GrafanaLokiAdapter implements CloudAdapter {
  final String url;
  final dynamic reqHeader;

  GrafanaLokiAdapter(this.url, this.reqHeader);

  @override
  Future<bool> syncJob(List<Log> logList) async {
    try {
      await upload(logList);

      return Future.value(true);
    } catch (e) {
      ExceptionHandler.log('Grafana sync failed - $e');

      return Future.value(false);
    }
  }

  Future<void> upload(List<Log> logList) async {
    try {
      await ApiHelper().post(url, reqHeader, getReqBody(logList));
    } catch (e) {
      ExceptionHandler.log('Grafana upload failed - $e');
    }
  }

  dynamic getReqBody(List<Log> logList) {
    return {
      "logs": logList.map((log) {
        return {
          'tag': log.tag,
          'msg': log.message,
          'exc': log.exc,
          'req': log.req,
          'res': log.res,
          'err': log.err,
          'props': log.props,
          'level': log.logLevel,
          'time': log.logTime,
          'file': log.fileName,
          'line': log.lineNumber,
          'func': log.functionName,
        };
      }).toList(),
    };
  }
}