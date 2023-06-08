import 'package:logify/models/log_list.dart';

abstract class CloudAdapter {
  /// Sync the logs with cloud
  Future<bool> syncJob(List<Log> logList);
}
