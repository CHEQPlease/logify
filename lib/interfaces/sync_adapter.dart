/// An abstract interface to sync logs from storage with cloud
abstract class SyncAdapter {
  /// Initialize the sync adapter
  Future<void> init();
  /// Sync the logs from storage with cloud
  Future<bool> sync();
  /// Clear the synced logs from the storage
  Future<void> clear();
}