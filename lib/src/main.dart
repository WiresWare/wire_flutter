library wire;

import 'package:flutter/widgets.dart';
import 'package:wire/wire.dart';

typedef WireDataWidgetBuilder<T> = Widget Function(
    BuildContext context, T value);

/// WireDataBuilder
class WireDataBuilder<T> extends StatefulWidget {
  WireDataBuilder({
    Key key,
    @required this.dataKey,
    @required this.builder,
  })  : assert(dataKey != null),
        assert(builder != null),
        super(key: key);

  final String dataKey;
  final WireDataWidgetBuilder builder;

  @override
  _WireDataBuilderState createState() => _WireDataBuilderState();
}

class _WireDataBuilderState extends State<WireDataBuilder> {
  var value;

  @override
  void initState() {
    super.initState();
    var wireData = Wire.data(widget.dataKey);
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
    if (widget != null) {
      var wireData = Wire.data(widget.dataKey);
      wireData?.unsubscribe(_onWireData);
    }
    value = null;
    super.dispose();
  }
}
