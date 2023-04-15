import 'package:flutter/foundation.dart';

abstract class CloudAdapter {
  /// Initialize the cloud adapter
  @protected
  Future<void> init();
  /// Sync the logs with cloud
  Future<void> sync();
}
