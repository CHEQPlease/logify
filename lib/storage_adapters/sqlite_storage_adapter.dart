import 'package:logify/enums/log_level_enum.dart';
import 'package:logify/interfaces/storage_adapter.dart';
import 'package:logify/models/log_list.dart';
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
    _dbName = SQLiteConfig.dbName;
    _logTableName = SQLiteConfig.logTableName;

    await open();
  }

  @override
  Future<void> open() async {
    try {
      _db = await sql.openDatabase(
        join(await sql.getDatabasesPath(), _dbName),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE IF NOT EXISTS ${SQLiteConfig.logTableName} (id INTEGER PRIMARY KEY, tag TEXT, message TEXT, log_level TEXT, log_time TEXT, file_name TEXT, line_number TEXT, function_name TEXT, is_synced INTEGER)',
          );
        },
        version: 1,
      );
    } catch (e) {
      throw ('Connection open - $e');
    }
  }

  @override
  Future<void> insert(
    String tag,
    dynamic message, {
    required LogLevel logLevel,
    required String logTime,
    required String fileName,
    required String lineNumber,
    required String functionName,
  }) async {
    try {
      await _db.insert(
        _logTableName,
        {
          'tag': tag,
          'message': message.toString(),
          'log_level': logLevel.name,
          'log_time': logTime,
          'file_name': fileName,
          'line_number': lineNumber,
          'function_name': functionName,
          'is_synced': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    } catch (e) {
      throw ('Logify, SQLite - $e');
    }
  }

  @override
  Future<List<Log>> getOutOfSync() async {
    try {

      final List<Map<String, dynamic>> maps = await _db.query(
        _logTableName,
        where: 'is_synced = ?',
        whereArgs: [0],
      );

      return List.generate(maps.length, (i) {
        return Log(
            id: maps[i]['id'],
            tag: maps[i]['tag'],
            message: maps[i]['message'],
            logLevel: maps[i]['log_level'],
            logTime: maps[i]['log_time'],
            fileName: maps[i]['file_name'],
            lineNumber: maps[i]['line_number'],
            functionName: maps[i]['function_name'],
            isSynced: maps[i]['is_synced']);
      });
    } catch (e) {
      throw ('Logify, SQLite - $e');
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
      throw ('Logify, SQLite - $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _db.delete(_logTableName);
    } catch (e) {
      throw ('Logify, SQLite - $e');
    }
  }

  @override
  Future<void> clearSynced() async {
    try {
      await _db.delete(_logTableName, where: 'is_synced = ?', whereArgs: [1]);
    } catch (e) {
      throw ('Logify, SQLite - $e');
    }
  }

  @override
  Future<void> close() async {
    try {
      await _db.close();
    } catch (e) {
      throw ('Connection close - $e');
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
