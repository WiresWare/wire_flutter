import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';

import 'base/DomElementView.dart';

class TodoCountView extends DomElement {
  TodoCountView(Element dom) : super(dom) {
    final countWireData = Wire.data<int>(DataKeys.COUNT);
    final update = (value) => dom.text = value.toString();
    countWireData.subscribe(update);
    update(countWireData.value);
  }
}
