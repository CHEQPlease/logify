import 'package:logify/interfaces/storage_adapter.dart';

class SQLiteStorageAdapter implements StorageAdapter {
  @override
  Future<void> init() {
    throw UnimplementedError();
  }

  @override
  Future<void> open() {
    throw UnimplementedError();
  }
  
  @override
  Future<void> set(String tag, value, String logTime, {LogLevel logLevel = LogLevel.info, String fileName = "", String functionName = "", int? lineNumber}) {
    throw UnimplementedError();
  }

  @override
  Future<void> clear() {
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    throw UnimplementedError();
  }
}