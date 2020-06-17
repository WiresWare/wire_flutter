library wire;

import 'package:flutter/widgets.dart';
import 'package:wire/wire.dart';

typedef WireDataWidgetBuilder<T> = Widget Function(BuildContext context, T value);

/// WireDataBuilder
class WireDataBuilder<T> extends StatefulWidget {
  WireDataBuilder({
    Key key,
    @required this.param,
    @required this.builder,
  }) :
      assert(param != null),
      assert(builder != null),
      super(key: key);

  final WireDataWidgetBuilder builder;
  final String param;

  @override
  _WireDataBuilderState createState() => _WireDataBuilderState();
}

class _WireDataBuilderState extends State<WireDataBuilder> {

  @override
  void initState() {
    super.initState();
    Wire.data(widget.param).subscribe(this, (value) {
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, Wire.data(widget.param).value);
  }

  @override
  void dispose() {
    Wire.data(widget.param).unsubscribe(this);
    super.dispose();
  }
}