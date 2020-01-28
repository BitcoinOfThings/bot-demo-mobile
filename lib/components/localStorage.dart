import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;

class LocalStorage {

  static void delete (key) async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: key);
  }


  static dynamic getJSON (key) async {
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: key);
    if (value == null) return value;
    return await convert.jsonDecode(value);
  }

  static void putJSON (key, value) async {
      final storage = new FlutterSecureStorage();
      await storage.write(key: "usercred", value: convert.jsonEncode(value));
  }

}