abstract class IDatabaseService {
  Future<bool> init([String key]);
  bool exist(String key);
  Future<dynamic> retrieve(String key);
  void save(String key, dynamic data);
}
