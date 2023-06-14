class StackTraceParser {
  late String fileName;
  late String lineNumber;
  late String functionName;

  StackTraceParser(StackTrace stackTrace) {
    _parse(stackTrace);
  }

  void _parse(StackTrace stackTrace) {
    try {
      /* The trace comes with multiple lines of strings, we are interested in second line, which has the information we need */
      String traceString = stackTrace.toString().split("\n")[1];

      /* Search through the string and find the index of the file name by looking for the '.dart' regex */
      int indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z]+.dart'));
      String fileInfo = traceString.substring(indexOfFileName);
      List<String> listOfInfos = fileInfo.split(":");
      fileName = listOfInfos[0];
      lineNumber = listOfInfos[1].replaceAll(RegExp(r'\D'), '');
      
      functionName = traceString
          .substring(
              traceString.indexOf(RegExp(r'[A-Za-z]')), traceString.indexOf('('))
          .trim();
    } catch (e) {
      throw ('Error while parsing stack trace $e');
    }
  }
}
