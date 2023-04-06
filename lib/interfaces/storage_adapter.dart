/// An abstract interface for save logs to storage
abstract class StorageAdapter {
  /// Initialize the storage adapter
  Future<void> init();
  /// Open connection to the storage
  Future<void> open();
  /// Insert a new log into the storage
  Future<void> set(
    String tag,
    dynamic value, {
    required LogLevel logLevel,
    required String logTime,
    required String fileName,
    required int lineNumber,
    required String functionName,
  });
  // Clear storage
  Future<void> clear();
  /// Close connection to the storage
  Future<void> close();
}

/// Enums for log levels
enum LogLevel { debug, info, warning, error, fatal }
