class StackTraceParser {
  late String fileName;
  late String lineNumber;
  late String functionName;

  StackTraceParser(StackTrace? stackTrace) {
    _parse(stackTrace);
  }

  void _parse(StackTrace? stackTrace) {
    try {
      String traceString;
      if (stackTrace != null) {
        traceString = stackTrace.toString().split("\n")[1]; /// While stackTrace is sent outside package
      } else {
        traceString = StackTrace.current.toString().split("\n")[4]; /// While stackTrace is determined inside package
      }

      /* Search through the string and find the index of the file name by looking for the '.dart' regex */
      int indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z0-9-_]+.dart'));
      String fileInfo = traceString.substring(indexOfFileName);
      List<String> listOfInfos = fileInfo.split(":");
      fileName = listOfInfos[0];
      lineNumber = listOfInfos[1].replaceAll(RegExp(r'\D'), '');
      
      functionName = traceString
          .substring(
              traceString.indexOf(RegExp(r'[A-Za-z]')), traceString.indexOf('('))
          .trim();
    } catch (_) {
      fileName = 'Logify error parsing stack trace';
      lineNumber = 'Logify error parsing stack trace';
      functionName = 'Logify error parsing stack trace';
    }
  }
}
