import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:wire_example_shared/todo/data/vo/TodoVO.dart';

import 'IDatabaseService.dart';

class MobileDatabaseService extends IDatabaseService {
  late final Database _db;

  get store {
    return intMapStoreFactory.store('store');
  }

  MobileDatabaseService();

  @override
  Future<bool> init([String? key]) async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'application.db');
    DatabaseFactory dbFactory = databaseFactoryIo;
    _db = await dbFactory.openDatabase(dbPath, version: 1, onVersionChanged: (db, oldVersion, newVersion) async {
      if (oldVersion == 0) {
        final store = intMapStoreFactory.store('store');
        final id = key!.length;
        store.record(id).add(_db, new TodoVO('1', 'Read', 'books, journals, articles', false).toJson());
        store.record(id).add(_db, new TodoVO('2', 'Write', 'books, journals, articles', false).toJson());
        store.record(id).add(_db, new TodoVO('3', 'Travel', 'London, New York, Paris', false).toJson());
      }
      print('> MobileDatabaseService -> onVersionChanged: $oldVersion | $newVersion');
    });
    print('> MobileDatabaseService -> init: key = $key | dbPath = $dbPath');
    return Future.value(true);
  }

  @override
  bool exist(String key) {
    return true;
  }

  @override
  Future<dynamic> retrieve(String key) async {
    final result = await store.record(key.length).get(_db);
    print('> MobileDatabaseService -> retrieve: result = $result');
    return result;
  }

  @override
  void save(String key, dynamic data) {}
}
