library wire_flutter;

import 'package:flutter/widgets.dart';
import 'package:wire/wire.dart';

typedef Widget WireDataWidgetBuilder<S>(BuildContext context, S value);
typedef Widget WireDataWidgetNullBuilder(BuildContext context);

/// A Flutter widget that listens to data changes from the Wire data bus
/// and rebuilds its UI accordingly. It provides a reactive way to build widgets
/// based on the state managed by Wire.
class WireDataBuilder<T> extends StatefulWidget {
  /// The key used to identify the data in the Wire data bus.
  final String dataKey;

  /// A builder function that constructs the widget when data is available.
  /// It is called with the `BuildContext` and the data `value` of type [T].
  final WireDataWidgetBuilder<T> builder;

  /// An optional builder function that is called when the data is `null`
  /// and the generic type T is not nullable.
  /// If not provided, a `SizedBox.shrink()` is rendered in this case.
  final WireDataWidgetNullBuilder? nullBuilder;

  /// An optional condition to control whether the widget should rebuild on a data change.
  /// The widget rebuilds only if this function returns `true`.
  final bool Function(T value)? rebuildWhen;

  /// If `true`, the widget builds only once with the initial data and does not
  /// subscribe to subsequent data changes. Defaults to `false`.
  final bool isStatic;

  WireDataBuilder({
    Key? key,
    required this.dataKey,
    required this.builder,
    this.rebuildWhen,
    this.nullBuilder,
    this.isStatic = false,
  }) : super(key: key);

  @override
  _WireDataBuilderState<T> createState() => _WireDataBuilderState<T>();
}

class _WireDataBuilderState<T> extends State<WireDataBuilder<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.isStatic) return;
    Wire.data<T>(widget.dataKey).subscribe(_onWireData);
  }

  void _onWireData(T value) {
    print('> WireDataBuilder ${widget.dataKey} -> _onWireData: value = $value');
    if (!mounted) return;

    if (widget.rebuildWhen?.call(value) == false) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final T? value = Wire.data<T>(widget.dataKey).value;

    // `is T` correctly handles both nullable and non-nullable T.
    // If T is `String?`, `null is String?` is true, so builder is called.
    // If T is `String`, `null is String` is false, so fallback is used.
    if (value is T) {
      return widget.builder(context, value);
    }

    // This part is reached if `value` is null and T is a non-nullable type.
    return widget.nullBuilder?.call(context) ?? const SizedBox.shrink();
  }

  @override
  void dispose() {
    if (!widget.isStatic) {
      Wire.data<T>(widget.dataKey).unsubscribe(_onWireData);
    }
    print('> WireDataBuilder ${widget.dataKey} -> dispose');
    super.dispose();
  }
}
