library wire;

import 'package:flutter/widgets.dart';
import 'package:wire/wire.dart';

typedef WireDataWidgetBuilder<T> = Widget Function(
    BuildContext context, T value);

/// WireDataBuilder
class WireDataBuilder<T> extends StatefulWidget {
  final  String dataKey;
  final WireDataWidgetBuilder builder;

  WireDataBuilder({
    Key? key,
    required this.dataKey,
    required this.builder,
  })  : super(key: key);

  @override
  _WireDataBuilderState<T> createState() => _WireDataBuilderState<T>();
}

class _WireDataBuilderState<T> extends State<WireDataBuilder> {
  var value;

  @override
  void initState() {
    super.initState();
    final wireData = Wire.data<T>(widget.dataKey);
    this.value = wireData.value;
    wireData.subscribe(_onWireData);
  }

  void _onWireData(value) {
    if (value != null) this.value = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value);
  }

  @override
  void dispose() {
    var wireData = Wire.data<T>(widget.dataKey);
    if (!wireData.isSet && wireData.value == null)
      wireData.remove();
    else
      wireData.unsubscribe(_onWireData);

    value = null;
    super.dispose();
  }
}
