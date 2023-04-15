class LogList {
  List<Log>? logList;

  LogList({this.logList});
}

class Log {
  int? id;
  String? tag;
  dynamic message;
  String? logLevel;
  String? logTime;
  String? fileName;
  String? lineNumber;
  String? functionName;
  int? isSynced;

  Log({
    this.id,
    this.tag,
    this.message,
    this.logLevel,
    this.logTime,
    this.fileName,
    this.lineNumber,
    this.functionName,
    this.isSynced,
  });
}
