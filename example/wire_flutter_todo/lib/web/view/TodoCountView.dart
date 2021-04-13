import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';

import 'base/DomElementView.dart';

class TodoCountView extends DomElement {
  TodoCountView(Element dom) : super(dom) {
    var wireData = Wire.data(DataKeys.COUNT);
    var update = (value) => dom.firstChild.text = value.toString();
    wireData.subscribe(update);
    update(wireData.value);
  }
}
