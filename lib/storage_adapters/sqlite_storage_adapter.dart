import 'package:logify/enums/log_level_enum.dart';
import 'package:logify/interfaces/storage_adapter.dart';
import 'package:logify/models/log_list.dart';
import 'package:logify/utils/exception_handler.dart';
import 'package:logify/utils/json_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SQLiteStorageAdapter implements StorageAdapter {
  static final SQLiteStorageAdapter _instance = SQLiteStorageAdapter._internal();

  late final String _dbName;
  late final String _logTableName;
  late sql.Database _db;

  SQLiteStorageAdapter._internal();

  factory SQLiteStorageAdapter() {
    return _instance;
  }

  @override
  Future<void> init() async {
    try {
      _dbName = SQLiteConfig.dbName;
      _logTableName = SQLiteConfig.logTableName;

      await open();
    } catch (e) {
      ExceptionHandler.log('SQLiteStorageAdapter initialization error: $e');
    }
  }

  @override
  Future<void> open() async {
    try {
      _db = await sql.openDatabase(
        join(await sql.getDatabasesPath(), _dbName),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE IF NOT EXISTS ${SQLiteConfig.logTableName} (id INTEGER PRIMARY KEY, tag TEXT, message TEXT, exc TEXT, req TEXT, res TEXT, err TEXT, props TEXT, log_level TEXT, log_time TEXT, file_name TEXT, line_number TEXT, function_name TEXT, stack_trace TEXT, is_synced INTEGER)',
          );
        },
        version: 1,
      );
    } catch (e) {
      ExceptionHandler.log('SQLiteStorageAdapter connection open error: $e');
    }
  }

  @override
  Future<void> insert(
    String? tag,
    dynamic message,
    dynamic exc,
    dynamic req,
    dynamic res,
    dynamic err,
    Map<String, dynamic>? props,
    LogLevel logLevel,
    String logTime,
    String fileName,
    String lineNumber,
    String functionName,
    String stackTrace,
  ) async {
    try {
      await _db.insert(
        _logTableName,
        {
          'tag': tag,
          'message': message.toString(),
          'exc': exc.toString(),
          'req': JSON.tryEncode(req),
          'res': JSON.tryEncode(res),
          'err': JSON.tryEncode(err),
          'props': JSON.tryEncode(props),
          'log_level': logLevel.name,
          'log_time': logTime,
          'file_name': fileName,
          'line_number': lineNumber,
          'function_name': functionName,
          'stack_trace': stackTrace,
          'is_synced': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    } catch (e) {
      ExceptionHandler.log('SQLiteStorageAdapter data insert error: $e');
    }
  }

  @override
  Future<List<Log>> getOutOfSync() async {
    try {

      final List<Map<String, dynamic>> maps = await _db.query(
        _logTableName,
        where: 'is_synced = ?',
        whereArgs: [0],
        limit: 50,
      );

      return List.generate(maps.length, (i) {
        return Log(
            id: maps[i]['id'],
            tag: maps[i]['tag'],
            message: maps[i]['message'],
            exc: maps[i]['exc'],
            req: JSON.tryDecode(maps[i]['req']),
            res: JSON.tryDecode(maps[i]['res']),
            err: JSON.tryDecode(maps[i]['err']),
            props: JSON.tryDecode(maps[i]['props']),
            logLevel: maps[i]['log_level'],
            logTime: maps[i]['log_time'],
            fileName: maps[i]['file_name'],
            lineNumber: maps[i]['line_number'],
            functionName: maps[i]['function_name'],
            stackTrace: maps[i]['stack_trace'],
            isSynced: maps[i]['is_synced']);
      });
    } catch (e) {
      ExceptionHandler.log('SQLiteStorageAdapter get out of sync logs error: $e');

      return [];
    }
  }

  @override
  Future<void> updateAsSynced(List<Log>? logList) async {
    try {
      if (logList == null || logList.isEmpty) return;
      
      RangeIndex range = RangeIndex(logList.first.id.toString(), logList.last.id.toString());

      final String query =
          'UPDATE $_logTableName SET is_synced = 1 WHERE id BETWEEN ${range.start} AND ${range.end}';

      await _db.execute(query);
    } catch (e) {
      ExceptionHandler.log('SQLiteStorageAdapter update as synced logs error: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _db.delete(_logTableName);
    } catch (e) {
      ExceptionHandler.log('SQLiteStorageAdapter clear storage: $e');
    }
  }

  @override
  Future<void> clearSynced() async {
    try {
      await _db.delete(_logTableName, where: 'is_synced = ?', whereArgs: [1]);
    } catch (e) {
      ExceptionHandler.log('SQLiteStorageAdapter clear synced logs: $e');
    }
  }

  @override
  Future<void> close() async {
    try {
      await _db.close();
    } catch (e) {
      ExceptionHandler.log('SQLiteStorageAdapter close database connection: $e');
    }
  }
}

class SQLiteConfig {
  SQLiteConfig._internal();

  static const String dbName = 'logify.db';
  static const String logTableName = 'logs';
}

class RangeIndex {
  final String start;
  final String end;

  RangeIndex(this.start, this.end);
}
