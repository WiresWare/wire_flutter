import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'IDatabaseService.dart';

class MobileDatabaseService extends IDatabaseService {
  late final Database _db;

  get store {
    return intMapStoreFactory.store('store');
  }

  MobileDatabaseService();

  var jsonList = <dynamic>[];

  @override
  Future<bool> init([String? key]) async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'application.db');
    _db = await databaseFactoryIo.openDatabase(dbPath);
    // final todoList = await store.record(key).get(_db);
    // print('> MobileDatabaseService -> init: todoList = $todoList');
    // jsonList.add({'id': '1', 'text': 'Read', 'note': 'books, journals, articles', 'completed': true});
    // jsonList.add({'id': '2', 'text': 'Write', 'note': 'books, journals, articles', 'completed': false});
    // jsonList.add({'id': '3', 'text': 'Travel', 'note': 'London, New York, Paris', 'completed': false});
    return Future.value(true);
  }

  @override
  bool exist(String key) {
    return true;
  }

  @override
  dynamic retrieve(String key) {
    return jsonList;
  }

  @override
  void save(String key, dynamic data) {}
}
