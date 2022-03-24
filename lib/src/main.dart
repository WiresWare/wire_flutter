library wire;

import 'package:flutter/widgets.dart';
import 'package:wire/wire.dart';

typedef WireDataWidgetBuilder<T> = Widget Function(
    BuildContext context, T value);

/// WireDataBuilder
class WireDataBuilder<T> extends StatefulWidget {
  final String dataKey;
  final WireDataWidgetBuilder builder;
  final bool Function(T)? rebuildCondition;

  WireDataBuilder({
    Key? key,
    required this.dataKey,
    required this.builder,
    this.rebuildCondition
  }) : super(key: key);

  @override
  _WireDataBuilderState<T> createState() => _WireDataBuilderState<T>();
}

class _WireDataBuilderState<T> extends State<WireDataBuilder> {
  @override
  void initState() {
    super.initState();
    Wire.data<T>(widget.dataKey)
      .subscribe(_onWireData);
  }

  Future<void> _onWireData(value) async {
    // print('> WireDataBuilder ${widget.dataKey} -> _onWireData: value = $value');
    if (!this.mounted || (widget.rebuildCondition != null && !widget.rebuildCondition!(value))) return;
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, Wire.data<T>(widget.dataKey).value as T?);
  }

  @override
  void dispose() {
    Wire.data<T>(widget.dataKey).unsubscribe(_onWireData);
    // print('> WireDataBuilder ${widget.dataKey} -> dispose');
    super.dispose();
  }
}
