/// An abstract interface for save logs to storage
abstract class StorageAdapter {
  /// Initialize the storage adapter
  Future<void> init();
  /// Open connection to the storage
  Future<void> open();
  /// Insert a new log into the storage
  Future<void> set(
    String tag,
    dynamic value,
    String logTime, {
    LogLevel logLevel = LogLevel.info,
    String fileName = "",
    String functionName = "",
    int? lineNumber,
  });
  // Clear storage
  Future<void> clear();
  /// Close connection to the storage
  Future<void> close();
}

/// Enums for log levels
enum LogLevel { debug, info, warning, error, fatal }
