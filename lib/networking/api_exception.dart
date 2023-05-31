class ApiException implements Exception {
  final String? _message;
  final String? _prefix;
  final int _responseCode;

  ApiException(this._responseCode, [this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }

  int getErrorCode() => _responseCode;
}

class FetchDataException extends ApiException {
  FetchDataException(int responseCode, [String? message])
      : super(responseCode, message, "Error During Communication: ");
}

class BadRequestException extends ApiException {
  BadRequestException(int responseCode, [message])
      : super(responseCode, message, "");
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(int responseCode, [message])
      : super(responseCode, message, "Unauthorized: ");
}

class InvalidInputException extends ApiException {
  InvalidInputException(int responseCode, [String? message])
      : super(responseCode, message, "Invalid Input: ");
}
