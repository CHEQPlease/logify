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
  Future<void> set(
    String tag,
    dynamic value, {
    required LogLevel logLevel,
    required String logTime,
    required String fileName,
    required int lineNumber,
    required String functionName,
  }) {
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