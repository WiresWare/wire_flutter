import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';

import 'base/DomElementView.dart';

class TodoCountView extends DomElement {
  TodoCountView(Element dom) : super(dom) {
    final dataCount = Wire.data(DataKeys.COUNT);
    final getterCountCompleted = Wire.data(DataKeys.GET_COUNT_COMPLETED);
    getterCountCompleted.subscribe((value) => updateCount(dataCount.value, value));
    updateCount(dataCount.value, getterCountCompleted.value);
  }

  Future<void> updateCount<int>(int count, int completedCount) async {
    dom.text = '${count.toString()} | ${completedCount.toString()}';
  }
}
