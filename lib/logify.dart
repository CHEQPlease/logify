library logify;

import 'package:logify/interfaces/storage_adapter.dart';
import 'package:logify/interfaces/sync_adapter.dart';
import 'package:logify/utils/stack_trace_parser.dart';

class Logify {
  late final StorageAdapter _storageAdapter;
  late final SyncAdapter _syncAdapter;

  Logify._internal(this._storageAdapter, this._syncAdapter);

  static Logify? _instance;

  static Future<void> init(StorageAdapter storageAdapter, SyncAdapter syncAdapter) async {
    _instance ??= Logify._internal(storageAdapter, syncAdapter);
    await _instance!._storageAdapter.init();
    await _instance!._syncAdapter.init();
  }

  static void log(
    dynamic message, {
    String tag = '',
    LogLevel logLevel = LogLevel.info,
  }) {
    try {
      if (_instance == null) {
        throw('Logify is not initialized');
      }
      
      StackTraceParser stackTraceParser = StackTraceParser(StackTrace.current);

      _instance!._storageAdapter.set(
        tag,
        message,
        logLevel: logLevel,
        logTime: DateTime.now().toIso8601String(),
        fileName: stackTraceParser.fileName,
        lineNumber: stackTraceParser.lineNumber,
        functionName: stackTraceParser.functionName,
      );
    } catch (e) {
      throw('Logify error: $e');
    }
  }
}