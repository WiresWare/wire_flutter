import 'package:wire/wire.dart';

class TodoMiddleware extends WireMiddleware {
  @override
  Future<void> onAdd(Wire<dynamic> wire) async {
    print('> TodoMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print('> TodoMiddleware -> onData - key: ${key} | value: ${nextValue}-${prevValue}');
  }

  @override
  Future<void> onRemove(String signal, [Object? scope, WireListener<dynamic>? listener]) async {
    print('> TodoMiddleware -> onRemove: signal = ${signal} | ${scope} | ${listener}');
  }

  @override
  Future<void> onSend(String signal, [dynamic payload, scope]) async {
    print('> TodoMiddleware -> onSend: signal = ${signal} | payload = ${payload} | scope = ${scope}');
  }

  @override
  Future<void> onDataError(error, String key, value) async {
    print('> TodoMiddleware -> onDataError: key = ${key} | value = ${value} | error = ${error}');
  }

  @override
  Future<void> onReset(String key, value) async {
    print('> TodoMiddleware -> onReset: key = ${key} | value = ${value}');
  }
}
