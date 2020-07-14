import 'IDatabaseService.dart';

class MobileDatabaseService extends IDatabaseService {
  MobileDatabaseService();

  var jsonList = <dynamic>[];

  @override
  Future init([String key]) async {

      jsonList.add({
        'id': '1',
        'text': 'Read',
        'note': 'books, journals, articles',
        'completed': true
      });

      jsonList.add({
        'id': '2',
        'text': 'Write',
        'note': 'books, journals, articles',
        'completed': false
      });

      jsonList.add({
        'id': '3',
        'text': 'Travel',
        'note': 'London, New York, Paris',
        'completed': false
      });
  }

  @override
  bool exist(String key) { return true; }

  @override
  dynamic retrieve(String key) {
    return jsonList;
  }

  @override
  void save(String key, dynamic data) {

  }
}
