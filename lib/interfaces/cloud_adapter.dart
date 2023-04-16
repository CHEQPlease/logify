import 'package:flutter/foundation.dart';
import 'package:logify/models/log_list.dart';

abstract class CloudAdapter {
  /// Initialize the cloud adapter
  @protected
  Future<void> init();
  /// Sync the logs with cloud
  Future<bool> sync(List<Log> logList);
}
