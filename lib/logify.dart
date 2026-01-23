library logify;

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logify/enums/log_level_enum.dart';
import 'package:logify/interfaces/cloud_adapter.dart';
import 'package:logify/interfaces/storage_adapter.dart';
import 'package:logify/interfaces/sync_adapter.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/utils/exception_handler.dart';
import 'package:logify/utils/stack_trace_parser.dart';

class Logify {
  late final StorageAdapter _storageAdapter;
  late final SyncAdapter _syncAdapter;

  Logify._internal(this._storageAdapter, this._syncAdapter);

  static Logify? _instance;

  static Future<void> init(StorageAdapter storageAdapter, SyncAdapter syncAdapter, Duration syncInterval, Function syncCallback) async {
    try {
      if (_instance != null) {
        throw('Logify is already initialized');
      }
      
      _instance ??= Logify._internal(storageAdapter, syncAdapter);
      await _instance!._storageAdapter.init();
      await _instance!._syncAdapter.init(syncInterval, syncCallback);
    } catch (e) {
      ExceptionHandler.log('Logify initialization error: $e');
    }
  }

  static void log({
    dynamic message,
    String? tag,
    dynamic exc,
    dynamic req,
    dynamic res,
    dynamic err,
    Map<String, dynamic>? props,
    LogLevel logLevel = LogLevel.info,
    /// Send stackTrace to logify if you want use wrapper function to identify correct trace string
    StackTrace? stackTrace,
  }) {
    try {
      if (_instance == null) {
        throw('Logify is not initialized');
      }
      
      StackTraceParser stackTraceParser = StackTraceParser(stackTrace);

      _instance!._storageAdapter.insert(
        tag,
        message,
        exc,
        req,
        res,
        err,
        props,
        logLevel,
        DateTime.now().toIso8601String(),
        stackTraceParser.fileName,
        stackTraceParser.lineNumber,
        stackTraceParser.functionName,
        stackTrace.toString(),
      );
    } catch (e) {
      ExceptionHandler.log('Logify log error: $e');
    }
  }

  static void debug({
    dynamic message,
    String? tag,
    dynamic exc,
    dynamic req,
    dynamic res,
    dynamic err,
    Map<String, dynamic>? props,
    /// Send stackTrace to logify if you want use wrapper function to identify correct trace string
    StackTrace? stackTrace
  }) {
    try {
      log(
        message: message,
        tag: tag,
        exc: exc,
        req: req,
        res: res,
        err: err,
        props: props,
        logLevel: LogLevel.debug,
        stackTrace: stackTrace,
      );
    } catch (e) {
      ExceptionHandler.log('Logify debug level log error: $e');
    }
  }

  static void info({
    dynamic message,
    String? tag,
    dynamic exc,
    dynamic req,
    dynamic res,
    dynamic err,
    Map<String, dynamic>? props,
    /// Send stackTrace to logify if you want use wrapper function to identify correct trace string
    StackTrace? stackTrace,
  }) {
    try {
      log(
        message: message,
        tag: tag,
        exc: exc,
        req: req,
        res: res,
        err: err,
        props: props,
        logLevel: LogLevel.info,
        stackTrace: stackTrace,
      );
    } catch (e) {
      ExceptionHandler.log('Logify info level log error: $e');
    }
  }

  static void warning({
    dynamic message,
    String? tag,
    dynamic exc,
    dynamic req,
    dynamic res,
    dynamic err,
    Map<String, dynamic>? props,
    /// Send stackTrace to logify if you want use wrapper function to identify correct trace string
    StackTrace? stackTrace,
  }) {
    try {
      log(
        message: message,
        tag: tag,
        exc: exc,
        req: req,
        res: res,
        err: err,
        props: props,
        logLevel: LogLevel.warning,
        stackTrace: stackTrace,
      );
    } catch (e) {
      ExceptionHandler.log('Logify warning level log error: $e');
    }
  }

  static void error({
    dynamic message,
    String? tag,
    dynamic exc,
    dynamic req,
    dynamic res,
    dynamic err,
    Map<String, dynamic>? props,
    /// Send stackTrace to logify if you want use wrapper function to identify correct trace string
    StackTrace? stackTrace,
  }) {
    try {
      log(
        message: message,
        tag: tag,
        exc: exc,
        req: req,
        res: res,
        err: err,
        props: props,
        logLevel: LogLevel.error,
        stackTrace: stackTrace,
      );
    } catch (e) {
      ExceptionHandler.log('Logify error level log error: $e');
    }
  }

  static void fatal({
    dynamic message,
    String? tag,
    dynamic exc,
    dynamic req,
    dynamic res,
    dynamic err,
    Map<String, dynamic>? props,
    /// Send stackTrace to logify if you want use wrapper function to identify correct trace string
    StackTrace? stackTrace,
  }) {
    try {
      log(
        message: message,
        tag: tag,
        exc: exc,
        req: req,
        res: res,
        err: err,
        props: props,
        logLevel: LogLevel.fatal,
        stackTrace: stackTrace,
      );
    } catch (e) {
      ExceptionHandler.log('Logify fatal level log error: $e');
    }
  }

  static Future<void> initSync(StorageAdapter storageAdapter, SyncAdapter syncAdapter) async {
    try {
      if (_instance == null) {
        _instance = Logify._internal(storageAdapter, syncAdapter);
        await _instance!._storageAdapter.init();
      }
    } catch (e) {
      ExceptionHandler.log('Logify background sync task initialization error: $e');
    }
  }

  static void syncLogs(CloudAdapter cloudAdapter) async {
    try {
      if (_instance == null) {
        throw('Logify is not initialized');
      }

      if (await InternetConnectionChecker().hasConnection) {
        _instance!._syncAdapter.cloudSync(cloudAdapter);
      }
    } catch (e) {
      ExceptionHandler.log('Logify logs sync error: $e');
    }
  }

  static Future<List<Log>> getOutOfSyncLogs() async {
    try {
      if (_instance == null) {
        throw('Logify is not initialized');
      }
      
      return await _instance!._storageAdapter.getOutOfSync();
    } catch (e) {
      ExceptionHandler.log('Logify get out of sync logs error: $e');

      return [];
    }
  }

  static Future<void> updateAsSynced(List<Log>? logList) async {
    try {
      if (_instance == null) {
        throw('Logify is not initialized');
      }
      
      await _instance!._storageAdapter.updateAsSynced(logList);
    } catch (e) {
      ExceptionHandler.log('Logify update as synced error: $e');
    }
  }

  static Future<void> clearSynced() async {
    try {
      if (_instance == null) {
        throw ('Logify is not initialized');
      }

      await _instance!._storageAdapter.clearSynced();
    } catch (e) {
      ExceptionHandler.log('Logify clear synced logs error: $e');
    }
  }

    static Future<void> closeDatabaseConnection() async {
    try {
      if (_instance == null) {
        throw ('Logify is not initialized');
      }

      await _instance!._storageAdapter.close();
    } catch (e) {
      ExceptionHandler.log('Logify close database connection error: $e');
    }
  }
}