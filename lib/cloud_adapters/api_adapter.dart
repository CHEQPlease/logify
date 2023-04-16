import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/models/log_list.dart';

class ApiAdapter implements CloudAdapter {
  final String url;

  ApiAdapter(this.url);

  @override
  init() {
    throw UnimplementedError();
  }

  @override
  sync(List<Log> logList) {
    throw UnimplementedError();
  }

  upload() {
    throw UnimplementedError();
  }
}