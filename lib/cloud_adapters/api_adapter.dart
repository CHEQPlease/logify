import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/networking/api_helper.dart';

class ApiAdapter implements CloudAdapter {
  final String url;
  final dynamic reqHeader;
  final dynamic reqBody;

  ApiAdapter(this.url, this.reqHeader, this.reqBody);

  @override
  Future<bool> sync(List<Log> logList) async {
    try {
      await upload(logList);

      return Future.value(true);
    } catch (e) {
      throw ('Sync failed - $e');
    }
  }

  Future<void> upload(List<Log> logList) async {
    try {
      await ApiHelper().post(url, reqHeader, reqBody);
    } catch (e) {
      rethrow;
    }
  }
}