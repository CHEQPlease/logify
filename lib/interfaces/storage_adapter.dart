import 'package:logify/enums/log_level_enum.dart';
import 'package:logify/models/log_list.dart';

/// An abstract interface for save logs to storage
abstract class StorageAdapter {
  /// Initialize the storage adapter
  Future<void> init();
  /// Open connection to the storage
  Future<void> open();
  /// Insert a new log into the storage
  Future<void> insert(
    String? tag,
    dynamic message,
    dynamic exc,
    Map<String, dynamic>? req,
    Map<String, dynamic>? res,
    dynamic err,
    Map<String, dynamic>? props,
    LogLevel logLevel,
    String logTime,
    String fileName,
    String lineNumber,
    String functionName,
  );
  /// Get out of sync logs from the storage
  Future<List<Log>> getOutOfSync();
  /// Update logs as synced in the storage
  Future<void> updateAsSynced(List<Log>? logList);
  /// Clear storage
  Future<void> clear();
  /// Clear synced logs from the storage
  Future<void> clearSynced();
  /// Close connection to the storage
  Future<void> close();
}
