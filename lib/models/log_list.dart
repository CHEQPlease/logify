class LogList {
  List<Log>? logList;

  LogList({this.logList});
}

class Log {
  int? id;
  String? tag;
  String? message;
  String? exc;
  Map<String, dynamic>? req;
  Map<String, dynamic>? res;
  dynamic err;
  Map<String, dynamic>? props;
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
    this.exc,
    this.req,
    this.res,
    this.err,
    this.props,
    this.logLevel,
    this.logTime,
    this.fileName,
    this.lineNumber,
    this.functionName,
    this.isSynced,
  });

  Map<String, dynamic> uploadServerMap() {
    return {
      'tag': tag,
      'message': message,
      'exc': exc,
      'req': req,
      'res': res,
      'err': err,
      'props': props,
      'logLevel': logLevel,
      'logTime': logTime,
      'fileName': fileName,
      'lineNumber': lineNumber,
      'functionName': functionName,
    };
  }
}

class LogSyncModel {
  List<Log>? logList;

  LogSyncModel({this.logList});

  Map<String, dynamic> toJson() => {
        "logList": logList == null
            ? null
            : List<dynamic>.from(logList!.map((x) => x.uploadServerMap()))
      };
}
