import 'package:wire/wire.dart';

class TodoMiddleware extends WireMiddleware {
  @override
  void onAdd(Wire wire) {
    print(
        '> TodoMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  void onData(String key, prevValue, nextValue) {
    print(
        '> TodoMiddleware -> onData - key: ${key} | value: ${nextValue}-${prevValue}');
  }

  @override
  void onRemove(String signal, [Object? scope, WireListener? listener]) {
    print(
        '> TodoMiddleware -> onRemove: signal = ${signal} | ${scope} | ${listener}');
  }

  @override
  void onSend(String signal, [data, scope]) {
    print(
        '> TodoMiddleware -> onSend: signal = ${signal} | data = ${data} | scope = ${scope}');
  }
}
