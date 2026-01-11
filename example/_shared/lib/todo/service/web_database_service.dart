import 'dart:convert';
import 'package:web/web.dart';

import 'package:wire_example_shared/todo/service/abstract_database_service.dart';

class WebDatabaseService extends IDatabaseService {
  @override
  bool exist(String key) {
    final result = window.localStorage.getItem(key) != null;
    print('> WebDatabaseService -> exist: $key = $result');
    return result;
  }

  @override
  Future<dynamic> retrieve(String key) {
    final value = window.localStorage.getItem(key);
    return Future.value(value != null ? jsonDecode(value) : null);
  }

  @override
  void save(String key, dynamic data) {
    window.localStorage.setItem(key, jsonEncode(data));
  }

  @override
  Future<bool> init([String? key]) {
    return Future.value(true);
  }
}
