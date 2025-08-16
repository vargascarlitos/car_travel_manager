import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
 

class MyLogger {
  static void log(String message) {
    if (kDebugMode) {
      developer.log(message);
    }
  }
}