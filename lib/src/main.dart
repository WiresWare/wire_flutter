library wire_flutter;

import 'package:flutter/widgets.dart';
import 'package:wire/wire.dart';

typedef Widget WireDataWidgetBuilder<S>(BuildContext context, S value);
typedef Widget WireDataWidgetNullBuilder(BuildContext context);

/// WireDataBuilder
class WireDataBuilder<T> extends StatefulWidget {
  final String dataKey;
  final WireDataWidgetBuilder<T> builder;
  final WireDataWidgetNullBuilder? nullBuilder;
  final bool Function(T)? rebuildWhen;
  final bool isStatic;

  WireDataBuilder({
    Key? key,
    required this.dataKey,
    required this.builder,
    this.rebuildWhen,
    this.nullBuilder,
    this.isStatic = false
  }) : super(key: key);

  @override
  _WireDataBuilderState<T> createState() => _WireDataBuilderState<T>();
}

class _WireDataBuilderState<T> extends State<WireDataBuilder<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.isStatic) return;
    Wire.data(widget.dataKey)
      .subscribe(_onWireData);
  }

  Future<void> _onWireData(value) async {
    // print('> WireDataBuilder ${widget.dataKey} -> _onWireData: value = $value');
    if (!this.mounted || (widget.rebuildWhen != null && !widget.rebuildWhen!(value))) return;
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    final value = Wire.data(widget.dataKey).value;
    if (value == null && widget.nullBuilder != null) {
      return widget.nullBuilder!.call(context);
    } else {
      return widget.builder(context, value as T);
    }
  }

  @override
  void dispose() {
    if (!widget.isStatic) {
      Wire.data(widget.dataKey).unsubscribe(_onWireData);
    }
    // print('> WireDataBuilder ${widget.dataKey} -> dispose');
    super.dispose();
  }
}
