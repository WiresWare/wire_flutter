import 'dart:convert';
import 'dart:html';

import 'package:wire_example_shared/todo/service/abstract_database_service.dart';

class WebDatabaseService extends IDatabaseService {
  @override
  bool exist(String key) {
    final result = !!window.localStorage.containsKey(key);
    print('> WebDatabaseService -> exist: $key = $result');
    return result;
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
