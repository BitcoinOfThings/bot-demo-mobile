import 'dart:collection';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;

import 'exception_reporter.dart';

//temporary key/val storage if flutter storage not available
class TempStorage {
  static HashMap _storage = HashMap<String, String>();
  delete(key) {
    _storage.remove(key);
  }
  read(String key) async {
    return _storage[key];
  }
  write(String key, String value) async {
    _storage[key] = value;
  }
}

// uses FlutterSecureStorage or falls back to
// TempStorage if flutter storage not available
class LocalStorage {

  static Object _storage;
  
  static get storage {
    if (_storage == null) {
      try {
        _storage = FlutterSecureStorage();
      }
      catch (err) {
        ExceptionReporter.reportException("FlutterSecureStorage not available, falling back to TempStorage");
        _storage = TempStorage();
      }
    }
    return _storage;
  }

  static void delete (key) async {
    await storage.delete(key: key);
  }

  static dynamic getJSON (key) async {
    String value = await storage.read(key: key);
    if (value == null) return value;
    return await convert.jsonDecode(value);
  }

  static void putJSON (key, value) async {
      await storage.write(key: key, value: convert.jsonEncode(value));
  }

}