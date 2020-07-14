library wire;

import 'package:flutter/widgets.dart';
import 'package:wire/wire.dart';

typedef WireDataWidgetBuilder<T> = Widget Function(
    BuildContext context, T value);

/// WireDataBuilder
class WireDataBuilder<T> extends StatefulWidget {
  WireDataBuilder({
    Key key,
    @required String param,
    @required this.builder,
  })  : assert(param != null),
        assert(builder != null),
        super(key: key) {
    wireData = Wire.data(param);
  }

  final WireDataWidgetBuilder builder;
  WireData wireData;

  @override
  _WireDataBuilderState createState() => _WireDataBuilderState();
}

class _WireDataBuilderState extends State<WireDataBuilder> {
  @override
  void initState() {
    super.initState();
    widget.wireData.subscribe(this, (value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.wireData?.value);
  }

  @override
  void dispose() {
    if (widget != null) {
      widget.wireData?.unsubscribe(this);
      widget.wireData = null;
    }
    super.dispose();
  }
}
