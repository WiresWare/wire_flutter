import 'dart:html';
import 'dart:convert';

import 'IDatabaseService.dart';

class WebDatabaseService extends IDatabaseService {
  @override
  bool exist(String key) {
    return window.localStorage.containsKey(key);
  }

  @override
  dynamic retrieve(String key) {
    final value = window.localStorage[key];
    return value != null ? jsonDecode(value) : null;
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
