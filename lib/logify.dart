library logify;

import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/interfaces/storage_adapter.dart';
import 'package:logify/interfaces/sync_adapter.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/utils/stack_trace_parser.dart';

class Logify {
  late final StorageAdapter _storageAdapter;
  late final SyncAdapter _syncAdapter;

  Logify._internal(this._storageAdapter, this._syncAdapter);

  static Logify? _instance;

  static Future<void> init(StorageAdapter storageAdapter, SyncAdapter syncAdapter, Duration syncInterval, Function syncCallback) async {
    _instance ??= Logify._internal(storageAdapter, syncAdapter);
    await _instance!._storageAdapter.init();
    await _instance!._syncAdapter.init(syncInterval, syncCallback);
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

      _instance!._storageAdapter.insert(
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

  static void initSync(StorageAdapter storageAdapter, SyncAdapter syncAdapter) {
    try {
      if (_instance == null) {
        _instance = Logify._internal(storageAdapter, syncAdapter);
        _instance!._storageAdapter.init();
      }
    } catch (e) {
      throw('Logify error: $e');
    }
  }

  static void syncLogs(CloudAdapter cloudAdapter) {
    try {
      if (_instance == null) {
        throw('Logify is not initialized');
      }
      
      _instance!._syncAdapter.cloudSync(cloudAdapter);
    } catch (e) {
      throw('Logify error: $e');
    }
  }

  static Future<List<Log>> getOutOfSyncLogs() async {
    try {
      if (_instance == null) {
        throw('Logify is not initialized');
      }
      
      return await _instance!._storageAdapter.getOutOfSync();
    } catch (e) {
      throw('Logify error: $e');
    }
  }

  static Future<void> updateAsSynced(List<Log>? logList) async {
    try {
      if (_instance == null) {
        throw('Logify is not initialized');
      }
      
      await _instance!._storageAdapter.updateAsSynced(logList);
    } catch (e) {
      throw('Logify error: $e');
    }
  }

  static Future<void> clearSynced() async {
    try {
      if (_instance == null) {
        throw ('Logify is not initialized');
      }

      await _instance!._storageAdapter.clearSynced();
    } catch (e) {
      throw ('Logify error: $e');
    }
  }
}