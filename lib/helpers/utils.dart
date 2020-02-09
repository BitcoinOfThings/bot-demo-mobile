// static utility methods here
// could be extension methods

import 'dart:convert';

class Utils {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }
}