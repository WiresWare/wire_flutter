import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';

import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class TodoCountView extends DomElement {
  TodoCountView(Element dom) : super(dom) {

    final wireDataCount = Wire.data(DataKeys.COUNT);
    final wireDataGetterCountCompleted = Wire.data(DataKeys.GET_COUNT_COMPLETED);

    wireDataCount.subscribe((value) => updateCount(value, wireDataGetterCountCompleted.value));
    updateCount(wireDataCount.value, wireDataGetterCountCompleted.value);
  }

  Future<void> updateCount<int>(int count, int completedCount) async {
    dom.text = '${count.toString()} | ${completedCount.toString()}';
  }
}
