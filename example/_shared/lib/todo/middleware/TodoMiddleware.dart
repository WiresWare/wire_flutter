import 'package:wire/wire.dart';

class TodoMiddleware extends WireMiddleware {
  @override
  Future<void> onAdd(Wire wire) async {
    print(
        '> TodoMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print(
        '> TodoMiddleware -> onData - key: $key | value: $nextValue-$prevValue');
  }

  @override
  Future<void> onRemove(String signal, [Object? scope, WireListener? listener]) async {
    print(
        '> TodoMiddleware -> onRemove: signal = $signal | $scope | $listener');
  }

  @override
  Future<void> onSend(String signal, [data, scope]) async {
    print(
        '> TodoMiddleware -> onSend: signal = $signal | data = $data | scope = $scope');
  }
}
