import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';
import 'package:wire_example_shared/todo/service/abstract_database_service.dart';

class MobileDatabaseService extends IDatabaseService {
  MobileDatabaseService();

  late final Box<List<dynamic>> store;

  @override
  Future<bool> init([String? key]) async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    Hive.init(dir.path);
    store = await Hive.openBox('todos');
    if (!exist(key!)) {
      store.put(key, [
        TodoVO('1', 'Read', 'books, journals, articles', false).toJson(),
        TodoVO('2', 'Write', 'books, journals, articles', false).toJson(),
        TodoVO('3', 'Travel', 'London, New York, Paris', false).toJson()
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
    print('> MobileDatabaseService -> save: key = $key');
    if (data is List) store.put(key, data);
  }
}
