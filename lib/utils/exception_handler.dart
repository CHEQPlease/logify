import 'package:flutter/material.dart';

class ExceptionHandler {
  static void log(String err) {
    debugPrint(
      '----------------LOGIFY EXCEPTION----------------\n$err\n------------------------------------------------'
    );
  }
}