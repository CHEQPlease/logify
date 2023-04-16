/// An abstract interface to sync logs from storage with cloud
/// syncInterval: The interval at which the logs should be synced
/// cloudAdapter: The cloud adapter to sync the logs with [FirebaseAdapter] or [ApiAdapter]
abstract class SyncAdapter {
  /// Initialize the sync adapter
  Future<void> init(Duration syncInterval, Function syncCallback);
  /// Sync the logs from storage with cloud
  Future<void> sync();
  /// Clear the synced logs from the storage
  Future<void> clear();
}
