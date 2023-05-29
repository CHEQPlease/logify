import 'package:logify/interfaces/cloud_adapter.dart';

/// An abstract interface to sync logs from storage with cloud
/// syncInterval: The interval at which the logs should be synced
/// syncCallback: The callback function to be called at the sync interval
abstract class SyncAdapter {
  /// Initialize the sync adapter
  Future<void> init(Duration syncInterval, Function syncCallback);
  /// Sync the logs from storage with cloud
  Future<void> sync(CloudAdapter cloudAdapter);
  /// Clear the synced logs from the storage
  Future<void> clear();
}
