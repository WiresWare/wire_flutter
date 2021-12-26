import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../data/vo/TodoVO.dart';
import 'IDatabaseService.dart';

class MobileDatabaseService extends IDatabaseService {
  MobileDatabaseService();

  late final store;

  @override
  Future<bool> init([String? key]) async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    Hive.init(dir.path);
    store = await Hive.openBox('todos');
    if (!this.exist(key!)) {
      store.put(key, [
        new TodoVO('1', 'Read', 'books, journals, articles', false).toJson(),
        new TodoVO('2', 'Write', 'books, journals, articles', false).toJson(),
        new TodoVO('3', 'Travel', 'London, New York, Paris', false).toJson()
      ]);
    }
    print('> MobileDatabaseService -> init: key = $key');
    return Future.value(true);
  }

  @override
  bool exist(String key) {
    return store.containsKey(key);
  }

  @override
  Future<dynamic> retrieve(String key) async {
    final result = store.get(key);
    print('> MobileDatabaseService -> retrieve: result = $result');
    return result;
  }

  @override
  void save(String key, dynamic data) {
    store.put(key, data);
  }
}
