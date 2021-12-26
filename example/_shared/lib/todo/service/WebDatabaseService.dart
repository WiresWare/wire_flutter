import 'dart:convert';
import 'dart:html';

import 'IDatabaseService.dart';

class WebDatabaseService extends IDatabaseService {
  @override
  bool exist(String key) {
    return window.localStorage.containsKey(key);
  }

  @override
  Future<dynamic> retrieve(String key) {
    final value = window.localStorage[key];
    return Future.value(value != null ? jsonDecode(value) : null);
  }

  @override
  void save(String key, dynamic data) {
    window.localStorage[key] = jsonEncode(data);
  }

  @override
  Future<bool> init([String? key]) {
    return Future.value(true);
  }
}
