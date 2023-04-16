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
  }

  @override
  Future<void> open() async {
    try {
      _db = await sql.openDatabase(
        join(await sql.getDatabasesPath(), SQLiteConfig.dbName),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE IF NOT EXISTS ${SQLiteConfig.logTableName} (id INTEGER PRIMARY KEY, tag TEXT, message TEXT, log_level TEXT, log_time TEXT, file_name TEXT, line_number INTEGER, function_name TEXT, is_synced INTEGER)',
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
    required int lineNumber,
    required String functionName,
  }) async {
    try {
      await open();

      await _db.insert(
        _logTableName,
        {
          'tag': tag,
          'message': message.toString(),
          'log_level': logLevel.toString(),
          'log_time': logTime,
          'file_name': fileName,
          'line_number': lineNumber,
          'function_name': functionName,
          'is_synced': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await close();
    } catch (e) {
      throw ('Logify, SQLite - $e');
    }
  }

  @override
  Future<List<Log>> getOutOfSync() async {
    try {
      await open();

      final List<Map<String, dynamic>> maps = await _db.query(
        _logTableName,
        where: 'is_synced = ?',
        whereArgs: [0],
      );

      await close();

      return List.generate(maps.length, (i) {
        return Log(
            id: maps[i]['id'],
            tag: maps[i]['tag'],
            message: maps[i]['message'],
            logLevel: maps[i]['logLevel'],
            logTime: maps[i]['logTime'],
            fileName: maps[i]['fileName'],
            lineNumber: maps[i]['lineNumber'],
            functionName: maps[i]['functionName'],
            isSynced: maps[i]['isSynced']);
      });
    } catch (e) {
      throw ('Logify, SQLite - $e');
    }
  }

  @override
  Future<void> updateAsSynced(RangeIndex? range) async {
    try {
      if (range == null) {
        throw Exception('Range cannot be null while updating as synced');
      }
      await open();

      final String query =
          'UPDATE $_logTableName SET is_synced = 1 WHERE id BETWEEN ${range.start} AND ${range.end}';

      await _db.execute(query);

      await close();
    } catch (e) {
      throw ('Logify, SQLite - $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await open();

      await _db.delete(_logTableName);

      await close();
    } catch (e) {
      throw ('Logify, SQLite - $e');
    }
  }

  @override
  Future<void> clearSynced() async {
    try {
      await open();

      await _db.delete(_logTableName, where: 'is_synced = ?', whereArgs: [1]);

      await close();
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
